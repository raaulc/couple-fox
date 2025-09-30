package com.couplefox.shared.domain.model

import kotlinx.datetime.Instant

data class User(
    val id: String,
    val email: String,
    val name: String,
    val profileImageUrl: String? = null,
    val createdAt: Instant,
    val updatedAt: Instant
)
