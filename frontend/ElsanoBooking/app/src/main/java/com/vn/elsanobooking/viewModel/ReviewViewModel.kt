package com.vn.elsanobooking.viewModel

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vn.elsanobooking.data.api.RetrofitInstance
import com.vn.elsanobooking.data.models.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import retrofit2.HttpException

class ReviewViewModel : ViewModel() {
    private val _uiState = MutableStateFlow<UiState>(UiState.Initial)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    var isLoading by mutableStateOf(false)
        private set

    var error by mutableStateOf<String?>(null)
        private set

    private val _artistReviews = MutableStateFlow<List<ReviewData>>(emptyList())
    val artistReviews: StateFlow<List<ReviewData>> = _artistReviews.asStateFlow()

    private val _reviewStats = MutableStateFlow<ArtistReviewsData?>(null)
    val reviewStats: StateFlow<ArtistReviewsData?> = _reviewStats.asStateFlow()

    private val _appointmentReview = MutableStateFlow<ReviewData?>(null)
    val appointmentReview: StateFlow<ReviewData?> = _appointmentReview.asStateFlow()

    fun getArtistReviews(artistId: Int) {
        viewModelScope.launch {
            try {
                isLoading = true
                error = null
                _uiState.value = UiState.Loading

                val response = RetrofitInstance.ratingApi.getArtistReviews(artistId)
                if (response.success && response.data != null) {
                    _artistReviews.value = response.data.reviews
                    _reviewStats.value = response.data
                    _uiState.value = UiState.Success(response.message)
                } else {
                    error = response.message
                    _uiState.value = UiState.Error(response.message)
                }
            } catch (e: HttpException) {
                val errorMessage = when (e.code()) {
                    404 -> "Không tìm thấy đánh giá"
                    else -> "Lỗi: ${e.message()}"
                }
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } catch (e: Exception) {
                val errorMessage = "Lỗi khi tải đánh giá: ${e.message}"
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } finally {
                isLoading = false
            }
        }
    }

    fun submitReview(appointmentId: Int, rating: Int, content: String) {
        viewModelScope.launch {
            try {
                isLoading = true
                error = null
                _uiState.value = UiState.Loading

                val request = ReviewCreateRequest(
                    appointmentId = appointmentId,
                    rating = rating,
                    content = content
                )

                val response = RetrofitInstance.ratingApi.submitRating(request)
                if (response.success) {
                    _uiState.value = UiState.Success(response.message)
                } else {
                    error = response.message
                    _uiState.value = UiState.Error(response.message)
                }
            } catch (e: HttpException) {
                val errorMessage = when (e.code()) {
                    400 -> "Yêu cầu không hợp lệ"
                    404 -> "Không tìm thấy lịch hẹn"
                    else -> "Lỗi: ${e.message()}"
                }
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } catch (e: Exception) {
                val errorMessage = "Lỗi khi gửi đánh giá: ${e.message}"
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } finally {
                isLoading = false
            }
        }
    }

    fun getAppointmentReview(appointmentId: Int) {
        viewModelScope.launch {
            try {
                isLoading = true
                error = null
                _uiState.value = UiState.Loading

                val response = RetrofitInstance.ratingApi.getAppointmentReview(appointmentId)
                if (response.success && response.data != null) {
                    _appointmentReview.value = response.data
                    _uiState.value = UiState.Success(response.message)
                } else {
                    error = response.message
                    _uiState.value = UiState.Error(response.message)
                }
            } catch (e: HttpException) {
                val errorMessage = when (e.code()) {
                    404 -> "Không tìm thấy đánh giá"
                    else -> "Lỗi: ${e.message()}"
                }
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } catch (e: Exception) {
                val errorMessage = "Lỗi khi tải đánh giá: ${e.message}"
                error = errorMessage
                _uiState.value = UiState.Error(errorMessage)
            } finally {
                isLoading = false
            }
        }
    }

    sealed class UiState {
        object Initial : UiState()
        object Loading : UiState()
        data class Success(val message: String) : UiState()
        data class Error(val message: String) : UiState()
    }
} 