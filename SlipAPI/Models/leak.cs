namespace YourProject.Models
{
    public class Leak
    {
        public int Id { get; set; }
        public string PlatformName { get; set; } = "";
        public string Title { get; set; } = "";
        public string Summary { get; set; } = "";
        public DateTime PublishDate { get; set; }
        public string SourceUrl { get; set; } = "";
        public string SourceName { get; set; } = "";
    }
}
