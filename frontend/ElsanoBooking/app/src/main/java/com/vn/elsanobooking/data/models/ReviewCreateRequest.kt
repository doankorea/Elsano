package com.vn.elsanobooking.data.models

import com.google.gson.annotations.SerializedName

data class ReviewCreateRequest(
    @SerializedName("AppointmentId") val appointmentId: Int,
    @SerializedName("Rating") val rating: Int,
    @SerializedName("Content") val content: String
)

data class ReviewCreateResponse(
    @SerializedName("success") val success: Boolean,
    @SerializedName("message") val message: String,
    @SerializedName("data") val data: ReviewData? = null
) 