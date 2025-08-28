//
//  FAQItem.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 28/08/2025.
//

import Foundation

struct FAQItem {
    let question: String
    let answer: String
}

let faqs: [FAQItem] = [
    FAQItem(question: "What is the return policy?", answer: "You can return items within 30 days."),
    FAQItem(question: "How to reset my password?", answer: "Go to Settings → Account → Reset Password."),
    FAQItem(question: "Do you offer international shipping?", answer: "Yes, we ship worldwide.")
]
