using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YourProject.Data;
using YourProject.Models;

namespace YourProject.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlatformsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PlatformsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Platform>>> GetPlatforms()
        {
            return await _context.Platforms.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Platform>> GetPlatform(int id)
        {
            var platform = await _context.Platforms.FindAsync(id);
            if (platform == null) return NotFound();
            return platform;
        }

        [HttpPost]
        public async Task<ActionResult<Platform>> CreatePlatform(Platform platform)
        {
            _context.Platforms.Add(platform);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetPlatform), new { id = platform.Id }, platform);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePlatform(int id, Platform platform)
        {
            if (id != platform.Id) return BadRequest();
            _context.Entry(platform).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlatform(int id)
        {
            var platform = await _context.Platforms.FindAsync(id);
            if (platform == null) return NotFound();
            _context.Platforms.Remove(platform);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
