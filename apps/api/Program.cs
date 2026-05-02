using Npgsql;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Database connection string was not configured.");
}

builder.Services.AddSingleton(new NpgsqlDataSourceBuilder(connectionString).Build());

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () =>
{
    return Results.Ok(new
    {
        status = "healthy",
        service = "beyud-api",
        timestamp = DateTime.UtcNow
    });
});

app.MapGet("/api/status", async (NpgsqlDataSource dataSource) =>
{
    await using var command = dataSource.CreateCommand("SELECT COUNT(*) FROM contacts;");
    var contactsCount = await command.ExecuteScalarAsync();

    return Results.Ok(new
    {
        application = "BEYUD Platform",
        api = "beyud-api",
        status = "running",
        database = "connected",
        contacts = contactsCount,
        environment = app.Environment.EnvironmentName,
        timestamp = DateTime.UtcNow
    });
});

app.MapGet("/api/services", () =>
{
    var services = new[]
    {
        new
        {
            id = 1,
            name = "Cloud Infrastructure",
            description = "AWS infrastructure designed with production-style architecture."
        },
        new
        {
            id = 2,
            name = "Kubernetes Platform",
            description = "RKE2 Kubernetes cluster managed with Rancher."
        },
        new
        {
            id = 3,
            name = "CI/CD and GitOps",
            description = "Automation with GitHub Actions, Amazon ECR and Argo CD."
        },
        new
        {
            id = 4,
            name = "Observability",
            description = "Metrics and logs with Prometheus, Grafana, Loki and Promtail."
        }
    };

    return Results.Ok(services);
});

app.MapPost("/api/contact", async (ContactRequest request, NpgsqlDataSource dataSource) =>
{
    const string sql = """
        INSERT INTO contacts (
            name,
            email,
            company,
            subject,
            message,
            status,
            created_at
        )
        VALUES (
            @name,
            @email,
            @company,
            @subject,
            @message,
            'PENDING',
            NOW()
        )
        RETURNING id, name, email, company, subject, message, status, created_at, processed_at;
        """;

    await using var command = dataSource.CreateCommand(sql);

    command.Parameters.AddWithValue("name", request.Name);
    command.Parameters.AddWithValue("email", request.Email);
    command.Parameters.AddWithValue("company", (object?)request.Company ?? DBNull.Value);
    command.Parameters.AddWithValue("subject", request.Subject);
    command.Parameters.AddWithValue("message", request.Message);

    await using var reader = await command.ExecuteReaderAsync();

    if (!await reader.ReadAsync())
    {
        return Results.Problem("Contact could not be created.");
    }

    var response = new ContactResponse(
        reader.GetGuid(0),
        reader.GetString(1),
        reader.GetString(2),
        reader.IsDBNull(3) ? null : reader.GetString(3),
        reader.GetString(4),
        reader.GetString(5),
        reader.GetString(6),
        reader.GetDateTime(7),
        reader.IsDBNull(8) ? null : reader.GetDateTime(8)
    );

    return Results.Created($"/api/contact/{response.Id}", response);
});

app.Run();

record ContactRequest(
    string Name,
    string Email,
    string? Company,
    string Subject,
    string Message
);

record ContactResponse(
    Guid Id,
    string Name,
    string Email,
    string? Company,
    string Subject,
    string Message,
    string Status,
    DateTime CreatedAt,
    DateTime? ProcessedAt
);