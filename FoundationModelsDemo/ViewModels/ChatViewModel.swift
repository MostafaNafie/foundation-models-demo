//
//  ChatViewModel.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import Combine
import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText = ""
    @Published var isProcessing = false

    private let foundationModelsManager = FoundationModelsManager()

    @MainActor
    func onAppear() {
        checkModelAvailability()
    }

    @MainActor
    func sendMessageTapped() {
        handleMessageSent()
    }
}

private extension ChatViewModel {
    func checkModelAvailability() {
        let availability = foundationModelsManager.checkModelAvailability()
        messages.append(ChatMessage(text: availability.message))
    }

    func handleMessageSent() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userMessage = ChatMessage(text: messageText, isFromUser: true)
        messages.append(userMessage)

        let currentMessage = messageText
        messageText = ""

        if foundationModelsManager.isModelAvailable {
            generateResponse(for: currentMessage)
        } else {
            messages.append(ChatMessage(text: "I'm not available right now. Please check your Apple Intelligence settings."))
        }
    }

    func generateResponse(for input: String) {
        isProcessing = true
        Task {
            do {
                let response = try await foundationModelsManager.generateResponse(for: input)
                
                await MainActor.run {
                    isProcessing = false
                    messages.append(ChatMessage(text: response))
                }
            } catch {
                await MainActor.run {
                    isProcessing = false
                    messages.append(ChatMessage(text: "Sorry, I encountered an error. Please try again."))
                }
            }
        }
    }
}
