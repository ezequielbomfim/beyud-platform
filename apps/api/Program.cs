var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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

app.MapGet("/api/status", () =>
{
    return Results.Ok(new
    {
        application = "BEYUD Platform",
        api = "beyud-api",
        status = "running",
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

app.MapPost("/api/contact", (ContactRequest request) =>
{
    var response = new
    {
        id = Guid.NewGuid(),
        request.Name,
        request.Email,
        request.Company,
        request.Subject,
        request.Message,
        status = "PENDING",
        createdAt = DateTime.UtcNow
    };

    return Results.Created("/api/contact", response);
});

app.Run();

record ContactRequest(
    string Name,
    string Email,
    string? Company,
    string Subject,
    string Message
);