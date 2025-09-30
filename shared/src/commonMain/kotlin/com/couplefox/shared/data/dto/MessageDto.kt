package com.couplefox.shared.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class MessageDto(
    val id: String,
    val senderId: String,
    val receiverId: String,
    val content: String,
    val timestamp: String,
    val isRead: Boolean = false
)
