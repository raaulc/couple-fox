package com.couplefox.shared.domain.usecase

import com.couplefox.shared.data.repository.MessageRepository
import com.couplefox.shared.domain.model.Message

class GetMessagesUseCase(
    private val messageRepository: MessageRepository
) {
    suspend operator fun invoke(userId: String): Result<List<Message>> {
        return messageRepository.getMessages(userId)
    }
}
