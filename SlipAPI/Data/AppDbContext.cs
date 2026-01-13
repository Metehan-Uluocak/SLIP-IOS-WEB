using Microsoft.EntityFrameworkCore;
using YourProject.Models;

namespace YourProject.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Leak> Leaks { get; set; }
        public DbSet<Source> Sources { get; set; }
        public DbSet<Platform> Platforms { get; set; }
    }
}
