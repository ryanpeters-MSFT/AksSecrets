var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

var configuration = app.Services.GetRequiredService<IConfiguration>();

app.MapGet("/", () =>
{
    // OPTION 1: read from file in "secrets" folder
    var file = "secrets/apikey";

    if (File.Exists(file))
    {
        var fileApiKey = File.ReadAllText(file);

        if (!string.IsNullOrWhiteSpace(fileApiKey))
        {
            Console.WriteLine($"Found API key in file \"{file}\"...");

            // yeah, don't ever do this...
            return Results.Ok(fileApiKey);
        }
    }

    // OPTION 2: read from the environment variable
    var envApiKey = configuration["apikey"];

    if (!string.IsNullOrWhiteSpace(envApiKey))
    {
        Console.WriteLine("Found API key via environment variable \"apikey\"...");

        // seriously, this is awful...
        return Results.Ok(envApiKey);
    }

    return Results.BadRequest("No API key found!");
});

app.Run();