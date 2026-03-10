//
//  TomeTextField.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

// Tome TextField
struct TomeTextField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(Color.tomeSepia)
                Text(label)
                    .font(.custom("IMFellEnglish-Regular", size: 11))
                    .foregroundStyle(Color.tomeSepia)
            }
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.tomeParchment.opacity(focused ? 0.9 : 0.6))
                    .frame(height: 34)
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeInk)
                .focused($focused)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 2)
                .padding(.bottom, 6)
                
                Rectangle()
                    .fill(focused ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4))
                    .frame(height: focused ? 1.5 : 1)
                    .animation(.easeInOut(duration: 0.2), value: focused)
            }
        }
    }
}
