var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

// disabled for benchmark
//app.UseHttpsRedirection();
//app.UseAuthorization();

app.MapControllers();

app.Run();
