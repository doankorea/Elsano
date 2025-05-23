package com.vn.elsanobooking.data.models

import com.google.gson.annotations.SerializedName

data class ReviewResponse(
    @SerializedName("success") val success: Boolean,
    @SerializedName("message") val message: String,
    @SerializedName("data") val data: ReviewData? = null
)

data class ReviewData(
    @SerializedName("reviewId") val reviewId: Int,
    @SerializedName("appointmentId") val appointmentId: Int,
    @SerializedName("userId") val userId: Int,
    @SerializedName("artistId") val artistId: Int,
    @SerializedName("rating") val rating: Int,
    @SerializedName("content") val content: String?,
    @SerializedName("createdAt") val createdAt: String,
    @SerializedName("userName") val userName: String?,
    @SerializedName("userAvatar") val userAvatar: String?,
    @SerializedName("displayName") val displayName: String?
)

data class Review(
    val AppointmentId: Int,
    val UserId: Int,
    val ArtistId: Int,
    val Rating: Int,
    val Content: String,
    val CreatedAt: String,
    val User: User? = null,
    val Appointment: Appointment? = null
)

data class ArtistReviewsResponse(
    @SerializedName("success") val success: Boolean,
    @SerializedName("message") val message: String,
    @SerializedName("data") val data: ArtistReviewsData? = null
)

data class ArtistReviewsData(
    @SerializedName("reviews") val reviews: List<ReviewData>,
    @SerializedName("totalReviews") val totalReviews: Int,
    @SerializedName("averageRating") val averageRating: Double,
    @SerializedName("ratingDistribution") val ratingDistribution: List<RatingCount>
)

data class RatingCount(
    @SerializedName("rating") val rating: Int,
    @SerializedName("count") val count: Int
)