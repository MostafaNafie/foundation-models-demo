//
//  ContentView.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import SwiftUI

struct ChatScreen: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                messageListView()

                Divider()

                MessageInputView(
                    messageText: $viewModel.messageText,
                    isProcessing: viewModel.isProcessing,
                    onSend: viewModel.sendMessageTapped
                )
                .padding(.bottom, 8)
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension ChatScreen {
    func messageListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.messages) { message in
                    MessageBubbleView(message: message)
                        .id(message.id)
                }

                if viewModel.isProcessing {
                    TypingIndicatorView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .animation(.easeOut(duration: 0.3), value: viewModel.messages.count)
        .scrollPosition(id: .constant(viewModel.messages.last?.id), anchor: .bottom)
    }
}

#Preview {
    ChatScreen()
}
