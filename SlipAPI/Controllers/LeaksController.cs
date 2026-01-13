using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YourProject.Data;
using YourProject.Models;

namespace YourProject.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LeaksController : ControllerBase
    {
        private readonly AppDbContext _context;

        public LeaksController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Leak>>> GetLeaks()
        {
            return await _context.Leaks.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Leak>> GetLeak(int id)
        {
            var leak = await _context.Leaks.FindAsync(id);
            if (leak == null) return NotFound();
            return leak;
        }

        [HttpPost]
        public async Task<ActionResult<Leak>> CreateLeak(Leak leak)
        {
            _context.Leaks.Add(leak);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetLeak), new { id = leak.Id }, leak);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateLeak(int id, Leak leak)
        {
            if (id != leak.Id) return BadRequest();
            _context.Entry(leak).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLeak(int id)
        {
            var leak = await _context.Leaks.FindAsync(id);
            if (leak == null) return NotFound();
            _context.Leaks.Remove(leak);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
