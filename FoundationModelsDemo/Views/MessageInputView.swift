//
//  MessageInputView.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    let isProcessing: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $messageText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)
                .onSubmit {
                    onSend()
                }
                .disabled(isProcessing)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isProcessing ? .gray : .blue)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isProcessing)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MessageInputView(
        messageText: .constant("Hello"),
        isProcessing: false
    ) { }
    .padding()
}
