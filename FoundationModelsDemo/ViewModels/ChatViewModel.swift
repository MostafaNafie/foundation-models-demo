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
                messages.append(ChatMessage(text: "Hello! I'm ready to chat with you.", isFromUser: false))
            case .unavailable(let reason):
                messages.append(ChatMessage(text: unavailableMessage(reason), isFromUser: false))
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
            messages.append(ChatMessage(text: "I'm not available right now. Please check your Apple Intelligence settings.", isFromUser: false))
        }
    }

    func generateResponse(for input: String) {
        isProcessing = true
        messages.append(ChatMessage(text: "Sorry, I encountered an error. Please try again.", isFromUser: false))
        //        Task {
        //            do {
        //                let prompt = "You are a helpful AI assistant. Please respond to this message: \(input)"
        //                let response = try await model.generate(prompt: prompt)
        //
        //                await MainActor.run {
        //                    isProcessing = false
        //                    messages.append(ChatMessage(text: response, isFromUser: false))
        //                }
        //            } catch {
        //                await MainActor.run {
        //                    isProcessing = false
        //                    messages.append(ChatMessage(text: "Sorry, I encountered an error. Please try again.", isFromUser: false))
        //                }
        //            }
        //        }
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
