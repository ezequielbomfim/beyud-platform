using Npgsql;

namespace Beyud.Worker;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly NpgsqlDataSource _dataSource;

    public Worker(ILogger<Worker> logger, NpgsqlDataSource dataSource)
    {
        _logger = logger;
        _dataSource = dataSource;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("beyud-worker started at: {time}", DateTimeOffset.Now);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessPendingContactAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while processing pending contacts.");
            }

            await Task.Delay(TimeSpan.FromSeconds(10), stoppingToken);
        }
    }

    private async Task ProcessPendingContactAsync(CancellationToken stoppingToken)
    {
        await using var connection = await _dataSource.OpenConnectionAsync(stoppingToken);
        await using var transaction = await connection.BeginTransactionAsync(stoppingToken);

        Guid? contactId = null;
        string? name = null;
        string? email = null;
        string? subject = null;

        const string selectSql = """
            SELECT id, name, email, subject
            FROM contacts
            WHERE status = 'PENDING'
            ORDER BY created_at
            LIMIT 1
            FOR UPDATE SKIP LOCKED;
            """;

        await using (var selectCommand = new NpgsqlCommand(selectSql, connection, transaction))
        await using (var reader = await selectCommand.ExecuteReaderAsync(stoppingToken))
        {
            if (await reader.ReadAsync(stoppingToken))
            {
                contactId = reader.GetGuid(0);
                name = reader.GetString(1);
                email = reader.GetString(2);
                subject = reader.GetString(3);
            }
        }

        if (contactId is null)
        {
            _logger.LogInformation("No PENDING contacts found at: {time}", DateTimeOffset.Now);
            await transaction.CommitAsync(stoppingToken);
            return;
        }

        _logger.LogInformation(
            "Processing contact {contactId} - {name} - {email} - {subject}",
            contactId,
            name,
            email,
            subject
        );

        const string processingSql = """
            UPDATE contacts
            SET status = 'PROCESSING'
            WHERE id = @id;
            """;

        await using (var processingCommand = new NpgsqlCommand(processingSql, connection, transaction))
        {
            processingCommand.Parameters.AddWithValue("id", contactId.Value);
            await processingCommand.ExecuteNonQueryAsync(stoppingToken);
        }

        await Task.Delay(TimeSpan.FromSeconds(2), stoppingToken);

        const string processedSql = """
            UPDATE contacts
            SET status = 'PROCESSED',
                processed_at = NOW()
            WHERE id = @id;
            """;

        await using (var processedCommand = new NpgsqlCommand(processedSql, connection, transaction))
        {
            processedCommand.Parameters.AddWithValue("id", contactId.Value);
            await processedCommand.ExecuteNonQueryAsync(stoppingToken);
        }

        await transaction.CommitAsync(stoppingToken);

        _logger.LogInformation(
            "Contact {contactId} processed successfully at: {time}",
            contactId,
            DateTimeOffset.Now
        );
    }
}