package com.couplefox.shared.data.repository

import com.couplefox.shared.data.dto.MessageDto
import com.couplefox.shared.data.mapper.MessageMapper
import com.couplefox.shared.domain.model.Message
import com.couplefox.shared.network.ApiService
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

interface MessageRepository {
    suspend fun getMessages(userId: String): Result<List<Message>>
    suspend fun sendMessage(message: Message): Result<Message>
    suspend fun markMessageAsRead(messageId: String): Result<Unit>
    fun getMessagesFlow(): Flow<List<Message>>
}

class MessageRepositoryImpl(
    private val apiService: ApiService
) : MessageRepository {
    
    private val _messages = MutableStateFlow<List<Message>>(emptyList())
    
    override suspend fun getMessages(userId: String): Result<List<Message>> {
        return try {
            val response = apiService.getMessages(userId)
            if (response.success && response.data != null) {
                val messages = response.data.map { MessageMapper.toDomain(it) }
                _messages.value = messages
                Result.success(messages)
            } else {
                Result.failure(Exception(response.message ?: "Failed to get messages"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override suspend fun sendMessage(message: Message): Result<Message> {
        return try {
            val messageDto = MessageMapper.toDto(message)
            val response = apiService.sendMessage(messageDto)
            if (response.success && response.data != null) {
                val sentMessage = MessageMapper.toDomain(response.data)
                val currentMessages = _messages.value.toMutableList()
                currentMessages.add(sentMessage)
                _messages.value = currentMessages
                Result.success(sentMessage)
            } else {
                Result.failure(Exception(response.message ?: "Failed to send message"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override suspend fun markMessageAsRead(messageId: String): Result<Unit> {
        return try {
            val response = apiService.markMessageAsRead(messageId)
            if (response.success) {
                // Update local state
                val currentMessages = _messages.value.toMutableList()
                val messageIndex = currentMessages.indexOfFirst { it.id == messageId }
                if (messageIndex != -1) {
                    currentMessages[messageIndex] = currentMessages[messageIndex].copy(isRead = true)
                    _messages.value = currentMessages
                }
                Result.success(Unit)
            } else {
                Result.failure(Exception(response.message ?: "Failed to mark message as read"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override fun getMessagesFlow(): Flow<List<Message>> {
        return _messages.asStateFlow()
    }
}
