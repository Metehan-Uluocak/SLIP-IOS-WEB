using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YourProject.Data;
using YourProject.Models;

namespace YourProject.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SourcesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SourcesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Source>>> GetSources()
        {
            return await _context.Sources.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Source>> GetSource(int id)
        {
            var source = await _context.Sources.FindAsync(id);
            if (source == null) return NotFound();
            return source;
        }

        [HttpPost]
        public async Task<ActionResult<Source>> CreateSource(Source source)
        {
            _context.Sources.Add(source);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetSource), new { id = source.Id }, source);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateSource(int id, Source source)
        {
            if (id != source.Id) return BadRequest();
            
            var existingSource = await _context.Sources.FindAsync(id);
            if (existingSource == null) return NotFound();
            
            existingSource.Name = source.Name;
            existingSource.Url = source.Url;
            existingSource.Description = source.Description;
            
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return StatusCode(500, "Update failed");
            }
            
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSource(int id)
        {
            var source = await _context.Sources.FindAsync(id);
            if (source == null) return NotFound();
            _context.Sources.Remove(source);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
