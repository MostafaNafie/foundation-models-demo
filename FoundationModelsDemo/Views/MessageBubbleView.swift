//
//  MessageBubble.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(message.isFromUser ? Color.blue : Color(.systemGray5))
                    )
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout)  {
    VStack {
        MessageBubbleView(
            message: ChatMessage(
                text: "Hi Apple Intelligence!",
                isFromUser: true
            )
        )
        MessageBubbleView(
            message: ChatMessage(
                text: "Hello, how can I assist you today?",
                isFromUser: false
            )
        )
    }
    .padding()
}
