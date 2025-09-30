package com.couplefox.shared.di

import com.couplefox.shared.data.repository.MessageRepository
import com.couplefox.shared.data.repository.MessageRepositoryImpl
import com.couplefox.shared.data.repository.UserRepository
import com.couplefox.shared.data.repository.UserRepositoryImpl
import com.couplefox.shared.domain.usecase.GetCurrentUserUseCase
import com.couplefox.shared.domain.usecase.GetMessagesUseCase
import com.couplefox.shared.domain.usecase.SendMessageUseCase
import com.couplefox.shared.domain.usecase.UpdateUserUseCase
import com.couplefox.shared.network.ApiClient
import com.couplefox.shared.network.ApiService
import com.couplefox.shared.network.ApiServiceImpl

object ServiceLocator {
    // Configuration
    private const val BASE_URL = "https://api.couplefox.com/v1"
    
    // Network layer
    private val apiClient by lazy { ApiClient() }
    private val apiService: ApiService by lazy { ApiServiceImpl(apiClient, BASE_URL) }
    
    // Repository layer
    val userRepository: UserRepository by lazy { UserRepositoryImpl(apiService) }
    val messageRepository: MessageRepository by lazy { MessageRepositoryImpl(apiService) }
    
    // Use case layer
    val getCurrentUserUseCase: GetCurrentUserUseCase by lazy { GetCurrentUserUseCase(userRepository) }
    val updateUserUseCase: UpdateUserUseCase by lazy { UpdateUserUseCase(userRepository) }
    val getMessagesUseCase: GetMessagesUseCase by lazy { GetMessagesUseCase(messageRepository) }
    val sendMessageUseCase: SendMessageUseCase by lazy { SendMessageUseCase(messageRepository) }
}
