//
//  ChatViewModel.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import Combine
import Foundation
import FoundationModels

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText = ""
    @Published var isProcessing = false

    private let model = SystemLanguageModel.default

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
        switch model.availability {
            case .available:
                messages.append(ChatMessage(text: "Hello! I'm ready to chat with you."))
            case .unavailable(let reason):
                messages.append(ChatMessage(text: unavailableMessage(reason)))
        }
    }

    func handleMessageSent() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userMessage = ChatMessage(text: messageText, isFromUser: true)
        messages.append(userMessage)

        let currentMessage = messageText
        messageText = ""

        if case .available = model.availability {
            generateResponse(for: currentMessage)
        } else {
            messages.append(ChatMessage(text: "I'm not available right now. Please check your Apple Intelligence settings."))
        }
    }

    func generateResponse(for input: String) {
        isProcessing = true
        Task {
            do {
                // Convert FAQ items into a prompt
                let faqText = faqs
                    .enumerated()
                    .map { index, faq in
                        "\(index+1). Q: \(faq.question)\n   A: \(faq.answer)"
                    }
                    .joined(separator: "\n\n")

                let instructions = """
                           You are a helpful FAQ assistant. Here is a list of FAQs:
                           
                           \(faqText)
                           
                           Based on the user’s question below, choose the most relevant answer from the FAQ list. 
                           If no FAQ is relevant, respond with: "Sorry, I don’t know the answer to that, you can call our customer service at 1-800-123-4567 for further assistance."
                           """

                let prompt = "You are a helpful AI assistant. Please respond to this message: \(input)"
                let session = LanguageModelSession(instructions: instructions)
                let response = try await session.respond(to: prompt)

                await MainActor.run {
                    isProcessing = false
                    messages.append(ChatMessage(text: response.content))
                }
            } catch {
                await MainActor.run {
                    isProcessing = false
                    messages.append(ChatMessage(text: "Sorry, I encountered an error. Please try again."))
                }
            }
        }
    }

    func unavailableMessage(_ reason: SystemLanguageModel.Availability.UnavailableReason) -> String {
        switch reason {
            case .deviceNotEligible:
                return "The device is not eligible for using Apple Intelligence."
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence is not enabled. Please enable it in Settings."
            case .modelNotReady:
                return "The model isn't ready because it's downloading or because of other system reasons."
            @unknown default:
                return "The model is unavailable for an unknown reason."
        }
    }
}
