using Microsoft.EntityFrameworkCore;
using YourProject.Data;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))
    )
);

// Add Controllers
builder.Services.AddControllers();

// CORS ayarı - Flutter Web, React Web ve Emulator için
builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterPolicy", policy =>
    {
        policy.WithOrigins(
                "http://localhost:5173",   // Flutter web
                "http://localhost:3000",   // React web
                "http://10.0.2.2:5173"    // Android emulator
            )
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// Swagger 
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Migration ve SeedData çalıştır
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
    SeedData.Initialize(db);
}

// Middleware
app.UseCors("FlutterPolicy");  // Burada policy ismini verdik

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();

// Health endpoints
app.MapGet("/", () => "SlipAPI is running");
app.MapGet("/health", () => Results.Ok(new { status = "Healthy", time = DateTime.UtcNow }));

// Map controllers
app.MapControllers();

app.Run();
