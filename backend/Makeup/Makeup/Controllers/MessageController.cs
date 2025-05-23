using Makeup.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Makeup.Controllers
{
    public class MessageController : Controller
    {
        private readonly IMessageService _messageService;

        public MessageController(IMessageService messageService)
        {
            _messageService = messageService;
        }

        public async Task<IActionResult> Index(string searchQuery)
        {
            var users = string.IsNullOrEmpty(searchQuery)
                ? await _messageService.GetUsers()
                : await _messageService.FilterUsersByName(searchQuery);

            // Nếu có người dùng, tự động chuyển hướng đến cuộc trò chuyện đầu tiên
            var usersList = users.ToList();
            if (usersList.Any())
            {
                return RedirectToAction("Chat", new { selectedUserId = usersList.First().Id });
            }

            return View(usersList);
        }
        [Authorize]
        public async Task<IActionResult> Chat(int selectedUserId)
        {
            var chatViewModel = await _messageService.GetMessages(selectedUserId);
            return View(chatViewModel);
        }
    }
}
