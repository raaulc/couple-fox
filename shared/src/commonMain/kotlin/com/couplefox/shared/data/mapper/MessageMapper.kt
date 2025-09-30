package com.couplefox.shared.data.mapper

import com.couplefox.shared.data.dto.MessageDto
import com.couplefox.shared.domain.model.Message
import kotlinx.datetime.Instant

object MessageMapper {
    fun toDomain(dto: MessageDto): Message {
        return Message(
            id = dto.id,
            senderId = dto.senderId,
            receiverId = dto.receiverId,
            content = dto.content,
            timestamp = Instant.parse(dto.timestamp),
            isRead = dto.isRead
        )
    }
    
    fun toDto(domain: Message): MessageDto {
        return MessageDto(
            id = domain.id,
            senderId = domain.senderId,
            receiverId = domain.receiverId,
            content = domain.content,
            timestamp = domain.timestamp.toString(),
            isRead = domain.isRead
        )
    }
}
