package com.vn.elsanobooking.data.models

import com.google.gson.annotations.SerializedName

data class BookAppointmentRequest(
    @SerializedName("ArtistId") val artistId: Int,
    @SerializedName("ServiceDetailId") val serviceDetailId: Int,
    @SerializedName("StartTime") val startTime: String,
    @SerializedName("EndTime") val endTime: String,
    @SerializedName("MeetingLocation") val meetingLocation: String,
    @SerializedName("UserId") val userId: Int,
    @SerializedName("PaymentMethod") val paymentMethod: String,
    @SerializedName("Latitude") val latitude: Double? = null,
    @SerializedName("Longitude") val longitude: Double? = null,
    @SerializedName("LocationType") val locationType: String? = null
)