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
//        let prompt = "You are a helpful AI assistant. Please respond to this message: \(input)"
        let options = GenerationOptions(
            sampling: .greedy,
            temperature: 0.0
        )
        let response = try await setupSession().respond(to: input, options: options)
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
                                 
                   
                    if the question is not exactly as you expect but delivers the same meaning, it's okay, you can answer with the bullet points you have. 

                    You are a helpful AI assistant. Use the following information to answer user questions:
                   - we work at Yassir
                   - the return policy is within 30 days
                   - we ship worldwide.
                   - To reset password: Go to Settings → Account → Reset Password
                   - We provide a range of technology solutions including software development, IT consulting, cloud services, and hardware support
                   - You can reach us via email (support@yassir.com), phone (1-800-123-4567), or live chat, with support hours from 9 AM – 6 PM, Mon–Fri
                   - We provide 24/7 support for enterprise customers with premium service agreements
                   - Our headquarters are in [City, Country], with additional offices in other regions
                   - We work with clients worldwide and offer remote support across multiple time zones
                   - Demos can be scheduled through our website by filling out the request form
                   - We serve clients in finance, healthcare, e-commerce, education, and government sectors
                   - Our solutions are flexible and customizable to meet unique organizational needs
                   - We provide cloud-native applications and migration services for AWS, Azure, and Google Cloud
                   - We implement encryption, multi-factor authentication, and regular security audits
                   - We offer onboarding sessions, training workshops, and detailed documentation
                   - Pricing is subscription-based, with monthly, annual, and enterprise package options
                   - Our APIs and integration tools allow connectivity with popular platforms
                   - We offer maintenance and support for servers, networking equipment, and other hardware
                   - Issues and bugs can be reported via our help center or direct email to technical support
                   - A free trial is available for most of our software products
                   - Refunds are available under conditions outlined in our terms of service
                   - Regular updates are released automatically with new features and fixes
                   - Scalable enterprise solutions are available with dedicated account managers
                   - Job applications can be submitted directly through our Careers page
                   
                   each bullet point is a separate point for a separate question.
                                      
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
