package com.couplefox.shared.data.mapper

import com.couplefox.shared.data.dto.UserDto
import com.couplefox.shared.domain.model.User
import kotlinx.datetime.Instant

object UserMapper {
    fun toDomain(dto: UserDto): User {
        return User(
            id = dto.id,
            email = dto.email,
            name = dto.name,
            profileImageUrl = dto.profileImageUrl,
            createdAt = Instant.parse(dto.createdAt),
            updatedAt = Instant.parse(dto.updatedAt)
        )
    }
    
    fun toDto(domain: User): UserDto {
        return UserDto(
            id = domain.id,
            email = domain.email,
            name = domain.name,
            profileImageUrl = domain.profileImageUrl,
            createdAt = domain.createdAt.toString(),
            updatedAt = domain.updatedAt.toString()
        )
    }
}
