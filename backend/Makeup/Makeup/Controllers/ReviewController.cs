using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Makeup.Models;
using Makeup.ViewModels;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace Makeup.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly MakeupContext _context;

        public ReviewController(MakeupContext context)
        {
            _context = context;
        }

        // POST: api/Review/rate
        [HttpPost("rate")]
        public async Task<IActionResult> CreateReview([FromBody] ReviewCreateDto review)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                var appointment = await _context.Appointments
                    .Include(a => a.User)
                    .Include(a => a.Artist)
                    .FirstOrDefaultAsync(a => a.AppointmentId == review.AppointmentId);

                if (appointment == null)
                {
                    return NotFound("Không tìm thấy lịch hẹn");
                }

                if (appointment.Status != "Completed")
                {
                    return BadRequest("Chỉ có thể đánh giá các lịch hẹn đã hoàn thành");
                }

                // Check if review already exists
                var existingReview = await _context.Reviews
                    .FirstOrDefaultAsync(r => r.AppointmentId == review.AppointmentId);

                if (existingReview != null)
                {
                    return BadRequest("Lịch hẹn này đã được đánh giá");
                }

                var newReview = new Review
                {
                    AppointmentId = review.AppointmentId,
                    UserId = (int)appointment.UserId,
                    ArtistId = (int)appointment.ArtistId.Value,
                    Rating = review.Rating,
                    Content = review.Content?.Trim() ?? string.Empty,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Reviews.Add(newReview);
                await _context.SaveChangesAsync();

                // Update artist's average rating
                var artistReviews = await _context.Reviews
                    .Where(r => r.ArtistId == appointment.ArtistId)
                    .ToListAsync();

                var averageRating = artistReviews.Average(r => r.Rating);
                var artist = await _context.MakeupArtists.FindAsync(appointment.ArtistId);
                if (artist != null)
                {
                    artist.Rating = (decimal?)averageRating;
                    await _context.SaveChangesAsync();
                }

                // Return simplified response
                return Ok(new
                {
                    success = true,
                    message = "Đánh giá đã được gửi thành công",
                    data = new
                    {
                        reviewId = newReview.ReviewId,
                        appointmentId = newReview.AppointmentId,
                        rating = newReview.Rating,
                        content = newReview.Content,
                        createdAt = newReview.CreatedAt
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = $"Lỗi: {ex.Message}" });
            }
        }

        // GET: api/Review/artist/{artistId}
        [HttpGet("artist/{artistId}")]
        public async Task<IActionResult> GetArtistReviews(int artistId)
        {
            try
            {
                var reviews = await _context.Reviews
                    .Include(r => r.User)
                    .Where(r => r.ArtistId == artistId)
                    .OrderByDescending(r => r.CreatedAt)
                    .Select(r => new
                    {
                        reviewId = r.ReviewId,
                        appointmentId = r.AppointmentId,
                        userId = r.UserId,
                        artistId = r.ArtistId,
                        rating = r.Rating,
                        content = r.Content,
                        createdAt = r.CreatedAt,
                        userName = r.User.UserName,
                        userAvatar = r.User.Avatar,
                        displayName = r.User.DisplayName
                    })
                    .ToListAsync();

                var artist = await _context.MakeupArtists
                    .Where(a => a.ArtistId == artistId)
                    .Select(a => new { a.Rating, a.ReviewsCount })
                    .FirstOrDefaultAsync();

                if (artist == null)
                {
                    return NotFound(new { success = false, message = "Không tìm thấy nghệ sĩ" });
                }

                var reviewCount = await _context.Reviews
                    .Where(r => r.ArtistId == artistId)
                    .CountAsync();

                var ratingDistribution = await _context.Reviews
                    .Where(r => r.ArtistId == artistId)
                    .GroupBy(r => r.Rating)
                    .Select(g => new { Rating = g.Key, Count = g.Count() })
                    .ToListAsync();

                // Update artist's review count if it's different from the actual count
                if (artist.ReviewsCount != reviewCount)
                {
                    var artistEntity = await _context.MakeupArtists.FindAsync(artistId);
                    if (artistEntity != null)
                    {
                        artistEntity.ReviewsCount = reviewCount;
                        await _context.SaveChangesAsync();
                    }
                }

                return Ok(new
                {
                    success = true,
                    message = "Lấy danh sách đánh giá thành công",
                    data = new
                    {
                        reviews,
                        totalReviews = reviewCount,
                        averageRating = artist.Rating ?? 0,
                        ratingDistribution
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "Đã xảy ra lỗi khi tải đánh giá", error = ex.Message });
            }
        }

        // GET: api/Review/appointment/{appointmentId}
        [HttpGet("appointment/{appointmentId}")]
        public async Task<IActionResult> GetAppointmentReview(int appointmentId)
        {
            try
            {
                var review = await _context.Reviews
                    .Include(r => r.User)
                    .Where(r => r.AppointmentId == appointmentId)
                    .Select(r => new
                    {
                        reviewId = r.ReviewId,
                        appointmentId = r.AppointmentId,
                        userId = r.UserId,
                        artistId = r.ArtistId,
                        rating = r.Rating,
                        content = r.Content,
                        createdAt = r.CreatedAt,
                        userName = r.User.UserName,
                        userAvatar = r.User.Avatar,
                        displayName = r.User.DisplayName
                    })
                    .FirstOrDefaultAsync();

                if (review == null)
                {
                    return NotFound(new { success = false, message = "Không tìm thấy đánh giá cho lịch hẹn này" });
                }

                return Ok(new
                {
                    success = true,
                    message = "Lấy đánh giá thành công",
                    data = review
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "Đã xảy ra lỗi khi tải đánh giá", error = ex.Message });
            }
        }
    }
}