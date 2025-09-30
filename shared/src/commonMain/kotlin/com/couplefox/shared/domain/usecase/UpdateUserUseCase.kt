package com.couplefox.shared.domain.usecase

import com.couplefox.shared.data.repository.UserRepository
import com.couplefox.shared.domain.model.User

class UpdateUserUseCase(
    private val userRepository: UserRepository
) {
    suspend operator fun invoke(user: User): Result<User> {
        return userRepository.updateUser(user)
    }
}
