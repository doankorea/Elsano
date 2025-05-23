package com.vn.elsanobooking.data.models

data class User(
    val id: Int = 0,
    val name: String,
    val displayName: String? = null,
    val isActive: Boolean,
    val avatar: String?
)