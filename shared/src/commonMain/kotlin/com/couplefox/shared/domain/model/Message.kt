package com.couplefox.shared.domain.model

import kotlinx.datetime.Instant

data class Message(
    val id: String,
    val senderId: String,
    val receiverId: String,
    val content: String,
    val timestamp: Instant,
    val isRead: Boolean = false
)
