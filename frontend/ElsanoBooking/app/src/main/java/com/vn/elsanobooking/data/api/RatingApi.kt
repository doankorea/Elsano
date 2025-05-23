package com.vn.elsanobooking.data.api

import com.vn.elsanobooking.data.models.ReviewCreateRequest
import com.vn.elsanobooking.data.models.ReviewCreateResponse
import com.vn.elsanobooking.data.models.ReviewResponse
import com.vn.elsanobooking.data.models.ArtistReviewsResponse
import retrofit2.http.*

interface RatingApi {
    @GET("api/Review/artist/{artistId}")
    suspend fun getArtistReviews(
        @Path("artistId") artistId: Int
    ): ArtistReviewsResponse

    @POST("api/Review/rate")
    @Headers("Content-Type: application/json")
    suspend fun submitRating(
        @Body request: ReviewCreateRequest
    ): ReviewCreateResponse

    @GET("api/Review/appointment/{appointmentId}")
    suspend fun getAppointmentReview(
        @Path("appointmentId") appointmentId: Int
    ): ReviewResponse
} 