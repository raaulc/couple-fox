package com.couplefox.shared.network

import com.couplefox.shared.data.dto.ApiResponse
import com.couplefox.shared.data.dto.MessageDto
import com.couplefox.shared.data.dto.UserDto

interface ApiService {
    suspend fun getUser(id: String): ApiResponse<UserDto>
    suspend fun getCurrentUser(): ApiResponse<UserDto>
    suspend fun updateUser(user: UserDto): ApiResponse<UserDto>
    
    suspend fun getMessages(userId: String): ApiResponse<List<MessageDto>>
    suspend fun sendMessage(message: MessageDto): ApiResponse<MessageDto>
    suspend fun markMessageAsRead(messageId: String): ApiResponse<Unit>
}

class ApiServiceImpl(
    private val apiClient: ApiClient,
    private val baseUrl: String
) : ApiService {
    
    override suspend fun getUser(id: String): ApiResponse<UserDto> {
        return apiClient.get("$baseUrl/users/$id")
    }
    
    override suspend fun getCurrentUser(): ApiResponse<UserDto> {
        return apiClient.get("$baseUrl/users/me")
    }
    
    override suspend fun updateUser(user: UserDto): ApiResponse<UserDto> {
        return apiClient.put("$baseUrl/users/${user.id}", user)
    }
    
    override suspend fun getMessages(userId: String): ApiResponse<List<MessageDto>> {
        return apiClient.get("$baseUrl/users/$userId/messages")
    }
    
    override suspend fun sendMessage(message: MessageDto): ApiResponse<MessageDto> {
        return apiClient.post("$baseUrl/messages", message)
    }
    
    override suspend fun markMessageAsRead(messageId: String): ApiResponse<Unit> {
        return apiClient.put("$baseUrl/messages/$messageId/read", Unit)
    }
}
