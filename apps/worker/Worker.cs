namespace Beyud.Worker;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;

    public Worker(ILogger<Worker> logger)
    {
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("beyud-worker started at: {time}", DateTimeOffset.Now);

        while (!stoppingToken.IsCancellationRequested)
        {
            _logger.LogInformation("Searching for PENDING contacts at: {time}", DateTimeOffset.Now);

            await Task.Delay(5000, stoppingToken);

            _logger.LogInformation("No database configured yet. Simulating worker execution.");
        }
    }
}