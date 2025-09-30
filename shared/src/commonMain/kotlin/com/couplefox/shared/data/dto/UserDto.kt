package com.couplefox.shared.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class UserDto(
    val id: String,
    val email: String,
    val name: String,
    val profileImageUrl: String? = null,
    val createdAt: String,
    val updatedAt: String
)
