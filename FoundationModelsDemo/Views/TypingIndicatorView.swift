//
//  TypingIndicator.swift
//  FoundationModelsDemo
//
//  Created by Nafie on 27/08/2025.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                        .offset(y: animationOffset)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: animationOffset
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray5))
            )
            
            Spacer()
        }
        .onAppear {
            animationOffset = -4
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TypingIndicatorView()
        .padding()
}
