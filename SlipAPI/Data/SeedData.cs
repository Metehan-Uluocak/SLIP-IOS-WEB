using YourProject.Models;
using Microsoft.EntityFrameworkCore;

namespace YourProject.Data
{
    public static class SeedData
    {
        public static void Initialize(AppDbContext context)
        {
            context.Database.Migrate();

            if (!context.Users.Any())
            {
                context.Users.AddRange(
                    new User { Email = "admin@slip.com", Name = "Admin User", Role = UserRole.Admin },
                    new User { Email = "analist@slip.com", Name = "Analist User", Role = UserRole.Analist },
                    new User { Email = "user@slip.com", Name = "Normal User", Role = UserRole.User }
                );
            }

            if (!context.Sources.Any())
            {
                context.Sources.AddRange(
                    new Source { Name = "SecurityHub", Url = "https://securityhub.com", Description = "Leading security news and vulnerability database platform" },
                    new Source { Name = "ThreatPost", Url = "https://threatpost.com", Description = "Cyber security news and analysis portal" },
                    new Source { Name = "GitHub Scanner", Url = "https://github-scanner.io", Description = "Automated GitHub repository security scanner" },
                    new Source { Name = "DockerScan", Url = "https://dockerscan.com", Description = "Docker container security analysis tool" },
                    new Source { Name = "CloudSecurity", Url = "https://cloudsecurity.com", Description = "Cloud infrastructure security monitoring service" }
                );
            }

            if (!context.Platforms.Any())
            {
                context.Platforms.AddRange(
                    new Platform { Name = "Microsoft Azure", Description = "Cloud computing platform and infrastructure services by Microsoft" },
                    new Platform { Name = "AWS", Description = "Amazon Web Services - comprehensive cloud computing platform" },
                    new Platform { Name = "GitHub", Description = "Web-based version control and collaboration platform for developers" },
                    new Platform { Name = "Docker Hub", Description = "Cloud-based registry service for Docker container images" },
                    new Platform { Name = "Google Cloud Platform", Description = "Suite of cloud computing services by Google" }
                );
            }

            if (!context.Leaks.Any())
            {
                context.Leaks.AddRange(
                    new Leak { PlatformName = "Microsoft Azure", Title = "Azure Storage Bucket Misconfiguration", Summary = "Critical security leak found in Azure storage configuration allowing unauthorized access to sensitive customer data.", PublishDate = DateTime.UtcNow.AddDays(-1), SourceUrl = "https://securityhub.com/azure-leak-2024", SourceName = "SecurityHub" },
                    new Leak { PlatformName = "AWS", Title = "S3 Bucket Exposed", Summary = "Public S3 bucket discovered containing sensitive data including API keys and customer information.", PublishDate = DateTime.UtcNow.AddDays(-2), SourceUrl = "https://threatpost.com/aws-s3-exposure", SourceName = "ThreatPost" },
                    new Leak { PlatformName = "GitHub", Title = "GitHub Repository Leaked Credentials", Summary = "Multiple repositories found with hardcoded credentials and private keys in commit history.", PublishDate = DateTime.UtcNow.AddDays(-3), SourceUrl = "https://github-scanner.io/leak-report", SourceName = "GitHub Scanner" },
                    new Leak { PlatformName = "Docker Hub", Title = "Docker Images with Embedded Secrets", Summary = "Several public Docker images contain embedded database passwords and API tokens.", PublishDate = DateTime.UtcNow.AddDays(-5), SourceUrl = "https://dockerscan.com/vulnerability-report", SourceName = "DockerScan" },
                    new Leak { PlatformName = "Microsoft Azure", Title = "Azure Key Vault Access Misconfiguration", Summary = "Improper access controls on Azure Key Vault allowing potential data exfiltration.", PublishDate = DateTime.UtcNow.AddDays(-7), SourceUrl = "https://cloudsecurity.com/azure-keyvault-issue", SourceName = "CloudSecurity" }
                );
            }

            context.SaveChanges();
        }
    }
}
