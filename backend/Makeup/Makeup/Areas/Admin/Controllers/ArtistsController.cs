using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Makeup.Models;
using System.Threading.Tasks;
using System.Linq;
using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;

namespace Makeup.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class ArtistsController : Controller
    {
        private readonly UserManager<User> _userManager;
        private readonly MakeupContext _context;
        private readonly ILogger<ArtistsController> _logger;

        public ArtistsController(
            UserManager<User> userManager,
            MakeupContext context,
            ILogger<ArtistsController> logger)
        {
            _userManager = userManager;
            _context = context;
            _logger = logger;
        }

        // GET: Admin/Artists
        public async Task<IActionResult> Index(string searchTerm, string status, int page = 1)
        {
            try
            {
                var pageSize = 10; // Số lượng item trên mỗi trang
                var skip = (page - 1) * pageSize; // Số lượng item bỏ qua
                
                var artistsQuery = _context.MakeupArtists
                    .Include(a => a.User)
                    .AsQueryable();

                // Filtering
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    searchTerm = searchTerm.Trim().ToLower();
                    artistsQuery = artistsQuery.Where(a => 
                        (a.FullName != null && a.FullName.ToLower().Contains(searchTerm)) ||
                        (a.User.Email != null && a.User.Email.ToLower().Contains(searchTerm)) ||
                        (a.User.PhoneNumber != null && a.User.PhoneNumber.Contains(searchTerm)) ||
                        (a.Specialty != null && a.Specialty.ToLower().Contains(searchTerm)));
                }

                if (!string.IsNullOrEmpty(status))
                {
                    if (status == "active")
                    {
                        artistsQuery = artistsQuery.Where(a => a.IsActive == 1);
                    }
                    else if (status == "inactive")
                    {
                        artistsQuery = artistsQuery.Where(a => a.IsActive == 0 || a.IsActive == null);
                    }
                }

                // Count total items for pagination
                var totalItems = await artistsQuery.CountAsync();
                
                // Tính toán số trang
                var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);
                
                // Đảm bảo trang hiện tại nằm trong phạm vi hợp lệ
                page = Math.Max(1, Math.Min(page, totalPages));

                // Apply pagination and ordering
                var artists = await artistsQuery
                    .OrderByDescending(a => a.User.CreatedAt)
                    .Skip(skip)
                    .Take(pageSize)
                    .ToListAsync();

                // Set ViewBag variables for pagination and filtering
                ViewBag.SearchTerm = searchTerm;
                ViewBag.Status = status;
                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalItems = totalItems;
                ViewBag.PageSize = pageSize;
                ViewBag.Skip = skip;

                // Pagination helpers
                ViewBag.HasPreviousPage = page > 1;
                ViewBag.HasNextPage = page < totalPages;

                // Calculate start and end pages for pagination
                var startPage = Math.Max(1, page - 2);
                var endPage = Math.Min(totalPages, startPage + 4);
                startPage = Math.Max(1, endPage - 4);

                ViewBag.StartPage = startPage;
                ViewBag.EndPage = endPage;
                ViewBag.ShowFirstPage = startPage > 1;
                ViewBag.ShowLastPage = endPage < totalPages;

                return View(artists);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading artists list");
                TempData["ErrorMessage"] = "Có lỗi xảy ra khi tải danh sách nghệ sĩ.";
                return View(new List<MakeupArtist>());
            }
        }

        // POST: Admin/Artists/ToggleStatus/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(int id, bool activate)
        {
            try
            {
                var artist = await _context.MakeupArtists
                    .Include(a => a.User)
                    .FirstOrDefaultAsync(a => a.ArtistId == id);

                if (artist == null)
                {
                    TempData["ErrorMessage"] = "Không tìm thấy nghệ sĩ.";
                    return RedirectToAction(nameof(Index));
                }

                // Set active status based on the activate parameter
                artist.IsActive = activate ? (byte)1 : (byte)0;

                // If artist is deactivated, deactivate the associated user account too
                if (!activate)
                {
                    artist.User.IsActive = (byte)0;
                    await _userManager.UpdateAsync(artist.User);
                }

                await _context.SaveChangesAsync();
                
                TempData["SuccessMessage"] = $"Đã {(activate ? "kích hoạt" : "vô hiệu hóa")} tài khoản nghệ sĩ {artist.FullName}.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling artist status");
                TempData["ErrorMessage"] = "Có lỗi xảy ra khi thay đổi trạng thái nghệ sĩ.";
            }

            return RedirectToAction(nameof(Index));
        }
    }
} 