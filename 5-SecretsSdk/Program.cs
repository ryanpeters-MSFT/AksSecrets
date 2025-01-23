using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

// Define the Key Vault URL and secret name
var keyVaultUrl = "https://secretsvaultrjp.vault.azure.net/";
var secretName = "mysecretvalue";

// Create a SecretClient using DefaultAzureCredential
var client = new SecretClient(new Uri(keyVaultUrl), new DefaultAzureCredential());

app.MapGet("/", async () =>
{
    // Retrieve the secret
    KeyVaultSecret secret = await client.GetSecretAsync(secretName);

    Console.WriteLine("Found API key using Key Vault SDK...");

    return Results.Ok(secret.Value);
});

app.Run();