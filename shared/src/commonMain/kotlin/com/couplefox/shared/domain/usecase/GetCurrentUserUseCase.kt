package com.couplefox.shared.domain.usecase

import com.couplefox.shared.data.repository.UserRepository
import com.couplefox.shared.domain.model.User

class GetCurrentUserUseCase(
    private val userRepository: UserRepository
) {
    suspend operator fun invoke(): Result<User> {
        return userRepository.getCurrentUser()
    }
}
