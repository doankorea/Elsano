using System.ComponentModel.DataAnnotations;
namespace Makeup.ViewModels
{
    public class ReviewCreateDto
    {
        [Required(ErrorMessage = "Vui lòng chọn lịch hẹn cần đánh giá")]
        public int AppointmentId { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn số sao đánh giá")]
        [Range(1, 5, ErrorMessage = "Đánh giá phải từ 1 đến 5 sao")]
        public int Rating { get; set; }

        [MaxLength(1000, ErrorMessage = "Nội dung đánh giá không được vượt quá 1000 ký tự")]
        public string Content { get; set; } = string.Empty;

    }
} 