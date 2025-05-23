using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Makeup.Models;
using System.Linq;
using System.Threading.Tasks;

namespace Makeup.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class ReviewsController : Controller
    {
        private readonly MakeupContext _context;

        public ReviewsController(MakeupContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(int? artistId, int? rating, int page = 1)
        {
            int pageSize = 10;
            var query = _context.Reviews
                .Include(r => r.User)
                .Include(r => r.Artist)
                .Include(r => r.Appointment)
                    .ThenInclude(a => a.ServiceDetail)
                        .ThenInclude(sd => sd.Service)
                .AsQueryable();

            // Apply filters
            if (artistId.HasValue)
            {
                query = query.Where(r => r.ArtistId == artistId);
            }

            if (rating.HasValue)
            {
                query = query.Where(r => r.Rating == rating);
            }

            // Get total count for pagination
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Get paginated data
            var reviews = await query
                .OrderByDescending(r => r.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Get all artists for filter dropdown
            ViewBag.Artists = await _context.MakeupArtists
                .OrderBy(a => a.FullName)
                .ToListAsync();
            ViewBag.SelectedArtistId = artistId;
            ViewBag.SelectedRating = rating;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(reviews);
        }

        public async Task<IActionResult> Details(int id)
        {
            var review = await _context.Reviews
                .Include(r => r.User)
                .Include(r => r.Artist)
                    .ThenInclude(a => a.User)
                .Include(r => r.Appointment)
                    .ThenInclude(a => a.ServiceDetail)
                        .ThenInclude(sd => sd.Service)
                .Include(r => r.Appointment)
                    .ThenInclude(a => a.Location)
                .FirstOrDefaultAsync(r => r.ReviewId == id);

            if (review == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy đánh giá này";
                return RedirectToAction(nameof(Index));
            }

            return View(review);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var review = await _context.Reviews
                .Include(r => r.Artist)
                .FirstOrDefaultAsync(r => r.ReviewId == id);

            if (review == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy đánh giá này";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                _context.Reviews.Remove(review);
                await _context.SaveChangesAsync();

                // Recalculate artist's average rating
                var artistReviews = await _context.Reviews
                    .Where(r => r.ArtistId == review.ArtistId)
                    .ToListAsync();

                if (artistReviews.Any())
                {
                    var averageRating = artistReviews.Average(r => r.Rating);
                    review.Artist.Rating = (decimal?)averageRating;
                }
                else
                {
                    review.Artist.Rating = null;
                }

                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã xóa đánh giá thành công";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Lỗi khi xóa đánh giá: {ex.Message}";
            }

            return RedirectToAction(nameof(Index));
        }
    }
} 