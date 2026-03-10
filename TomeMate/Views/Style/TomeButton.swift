//
//  TomeButton.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI


// Seal Button
struct SealButton: View {
    let label: String
    let isLoading: Bool
    let action: () -> Void
    
    init(_ label: String, isLoading: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.tomeParchment))
                        .scaleEffect(0.8)
                } else {
                    Text(label)
                        .font(.custom("Cinzel-Regular", size: 11))
                        .tracking(3)
                        .foregroundStyle(Color.tomeParchment)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color.tomeCrimson, Color("#A02020"), Color.tomeCrimson],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                LinearGradient(colors: [Color.white.opacity(0.08), .clear],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(2)
            .shadow(color: Color.tomeCrimson.opacity(0.45), radius: 14, x: 0, y: 5)
        }
        .buttonStyle(TomeButtonStyle())
        .disabled(isLoading)
    }
}

// Tome Button
struct TomeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
