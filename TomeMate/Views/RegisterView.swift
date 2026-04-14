//
//  RegisterView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var email: String = ""
    @State private var pwd: String = ""
    @State private var confirmPwd: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var appeared: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Begin anew")
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeCrimson)
                .tracking(2)
                .textCase(.uppercase)
                .padding(.bottom, 2)
                .fadeUp(appeared, delay: 0.05)
            
            Spacer()
                .frame(height: 18)
            
            // TextFields
            TomeTextField(label: "Email Address", icon: "envelope", placeholder: "Enter your email", text: $email)
                .fadeUp(appeared, delay: 0.15)
                .onChange(of: email) { _ in clearError() }
            
            Spacer()
                .frame(height: 14)
            
            TomeTextField(label: "Password", icon: "lock", placeholder: "Enter your password", text: $pwd, isSecure: true)
                .fadeUp(appeared, delay: 0.21)
                .onChange(of: pwd) { _ in clearError() }
            
            Spacer()
                .frame(height: 14)
            
            TomeTextField(label: "Re-enter password", icon: "lock.rotation", placeholder: "Re-enter your password", text: $confirmPwd, isSecure: true)
            
            // Error Banner
            if let msg = errorMessage {
                Spacer()
                    .frame(height: 10)
                TomeErrorView(message: msg)
            }
            
            Spacer()
                .frame(height: 18)
            
            SealButton("Sign Contract", isLoading: isLoading) {
                register()
            }
            .fadeUp(appeared, delay: 0.33)
            .disabled(!canSubmit)
            
            Spacer()
                .frame(height: 14)
            
            // Footer
            HStack {
                Spacer()
                Button("Already inscribed? Return to your tale") {
                    // Redirect to login
                }
                .font(.custom("IMFellEnglish-Regular", size: 12))
                .italic()
                .foregroundStyle(Color.tomeCrimsonLight)
                Spacer()
            }
            .fadeUp(appeared, delay: 0.38)
        }
        .onAppear { appeared = true }
    }
    
    // Private variables / methods
    private var canSubmit: Bool {
        !email.isEmpty && pwd.count >= 6 && !isLoading
    }
    
    private func clearError() {
        if errorMessage != nil { withAnimation { errorMessage = nil }}
    }
    
    private func register() {
        guard canSubmit else { return }
        guard pwd == confirmPwd else {
            withAnimation { errorMessage = TomeAuthError.passwordMismatch }
            return
        }
        isLoading = true
        withAnimation { errorMessage = nil }
        
        authManager.register(email: email, password: pwd) {
            result in
            DispatchQueue.main.async {
                isLoading = false
                if case .failure(let error) = result {
                    withAnimation { errorMessage = TomeAuthError.registerMessage(for: error) }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthManager())
}
