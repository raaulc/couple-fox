package com.couplefox.shared.network

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class ApiClient {
    val httpClient = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                prettyPrint = true
                isLenient = true
                ignoreUnknownKeys = true
            })
        }
        
        install(DefaultRequest) {
            header(HttpHeaders.ContentType, ContentType.Application.Json)
        }
        
        install(HttpTimeout) {
            requestTimeoutMillis = 10000
            connectTimeoutMillis = 10000
            socketTimeoutMillis = 10000
        }
    }
    
    suspend inline fun <reified T> get(url: String): T {
        return httpClient.get(url).body()
    }
    
    suspend inline fun <reified T, reified R> post(url: String, body: T): R {
        return httpClient.post(url) {
            setBody(body)
        }.body()
    }
    
    suspend inline fun <reified T, reified R> put(url: String, body: T): R {
        return httpClient.put(url) {
            setBody(body)
        }.body()
    }
    
    suspend fun delete(url: String) {
        httpClient.delete(url)
    }
}
