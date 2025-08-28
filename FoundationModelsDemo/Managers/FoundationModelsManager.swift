//
//  FoundationModelsManager.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import FoundationModels

final class FoundationModelsManager {
    private let model = SystemLanguageModel.default
    private lazy var session = setupSession()

    var isModelAvailable: Bool {
        model.availability == .available
    }

    func checkModelAvailability() -> (isAvailable: Bool, message: String) {
        switch model.availability {
        case .available:
            return (true, "Hello! I'm ready to chat with you.")
        case .unavailable(let reason):
            return (false, unavailableMessage(reason))
        }
    }
    
    func generateResponse(for input: String) async throws -> String {
        let prompt = "You are a helpful AI assistant. Please respond to this message: \(input)"
        let response = try await session.respond(to: prompt)
        return response.content
    }
}

private extension FoundationModelsManager {
    func setupSession() -> LanguageModelSession {
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
                   
                   Based on the user's question below, choose the most relevant answer from the FAQ list. 
                   If no FAQ is relevant, respond with: "Sorry, I don't know the answer to that, you can call our customer service at 1-800-123-4567 for further assistance."
                   """

        return LanguageModelSession(
            model: model,
            instructions: instructions
        )
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
