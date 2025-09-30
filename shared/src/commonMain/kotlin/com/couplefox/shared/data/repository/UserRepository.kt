package com.couplefox.shared.data.repository

import com.couplefox.shared.data.dto.UserDto
import com.couplefox.shared.data.mapper.UserMapper
import com.couplefox.shared.domain.model.User
import com.couplefox.shared.network.ApiService
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

interface UserRepository {
    suspend fun getCurrentUser(): Result<User>
    suspend fun getUser(id: String): Result<User>
    suspend fun updateUser(user: User): Result<User>
    fun getCurrentUserFlow(): Flow<User?>
}

class UserRepositoryImpl(
    private val apiService: ApiService
) : UserRepository {
    
    private val _currentUser = MutableStateFlow<User?>(null)
    
    override suspend fun getCurrentUser(): Result<User> {
        return try {
            val response = apiService.getCurrentUser()
            if (response.success && response.data != null) {
                val user = UserMapper.toDomain(response.data)
                _currentUser.value = user
                Result.success(user)
            } else {
                Result.failure(Exception(response.message ?: "Failed to get current user"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override suspend fun getUser(id: String): Result<User> {
        return try {
            val response = apiService.getUser(id)
            if (response.success && response.data != null) {
                Result.success(UserMapper.toDomain(response.data))
            } else {
                Result.failure(Exception(response.message ?: "Failed to get user"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override suspend fun updateUser(user: User): Result<User> {
        return try {
            val userDto = UserMapper.toDto(user)
            val response = apiService.updateUser(userDto)
            if (response.success && response.data != null) {
                val updatedUser = UserMapper.toDomain(response.data)
                if (user.id == _currentUser.value?.id) {
                    _currentUser.value = updatedUser
                }
                Result.success(updatedUser)
            } else {
                Result.failure(Exception(response.message ?: "Failed to update user"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    override fun getCurrentUserFlow(): Flow<User?> {
        return _currentUser.asStateFlow()
    }
}
