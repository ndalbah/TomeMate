//
//  LoginView.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var email: String = ""
    @State private var pwd: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var appeared: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter the Tome...")
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeCrimson)
                .tracking(2)
                .textCase(.uppercase)
                .padding(.bottom, 2)
                .fadeUp(appeared, delay: 0.05)
            
            Spacer()
                .frame(height: 24)
            
            // Text Fields
            TomeTextField(label: "Email Address", icon: "envelope", placeholder: "Enter your email", text: $email)
                .fadeUp(appeared, delay: 0.15)
                .onChange(of: email) { _ in clearError() }
            
            Spacer()
                .frame(height: 18)
            
            TomeTextField(label: "Password", icon: "lock", placeholder: "Enter your desired password", text: $pwd, isSecure: true)
                .fadeUp(appeared, delay: 0.22)
                .onChange(of: pwd) { _ in clearError() }
            
            if let msg = errorMessage {
                Spacer()
                    .frame(height: 12)
                TomeErrorView(message: msg)
            }
            
            Spacer()
                .frame(height: 24)
            
            HStack {
                Spacer()
                Button("Reset Password") {
                    // To implement in Phase 3 (?)
                }
                .font(.custom("IMFellEnglish-Regular", size: 12))
                .italic()
                .foregroundStyle(Color.tomeCrimsonLight)
                Spacer()
            }
            .fadeUp(appeared, delay: 0.36)
        }
        .onAppear { appeared = true }
    }
    
    private var canSubmit: Bool { !email.isEmpty && pwd.isEmpty && !isLoading }
    private func clearError() {
        if errorMessage != nil {
            withAnimation {
                errorMessage = nil
            }
        }
    }
    
    private func login() {
        guard canSubmit else { return }
        isLoading = true
        withAnimation { errorMessage = nil }
        authManager.login(email: email, password: pwd) {
            result in
            DispatchQueue.main.async {
                isLoading = false
                if case .failure(let error) = result {
                    withAnimation { errorMessage = TomeAuthError.loginMessage(for: error) }
                }
            }
        }
    }
}

#Preview {
    TomeAuthView()
        .environmentObject(AuthManager())
        .frame(width: 900, height: 700)
}
