//
//  ContentView.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {

    private var model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            Text("The model is available for use.")
        case .unavailable(let reason):
            Text(unavailableMessage(reason))
        }
    }

    private func unavailableMessage(_ reason: SystemLanguageModel.Availability.UnavailableReason) -> String {
        switch reason {
        case .deviceNotEligible:
            return "The device is not eligible for using Apple Intelligence."
        case .appleIntelligenceNotEnabled:
            return "Apple Intelligence is not enabled on this device."
        case .modelNotReady:
            return "The model isn't ready because it's downloading or because of other system reasons."
        @unknown default:
            return "The model is unavailable for an unknown reason."
        }
    }
}

#Preview {
    ContentView()
}
