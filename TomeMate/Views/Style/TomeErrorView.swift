//
//  TomeErrorView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct TomeErrorView: View {
    let message: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 11, weight: .light))
                .foregroundColor(Color.tomeCrimson)
            
            Text(message)
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeCrimson)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.tomeCrimson.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Color.tomeCrimson.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(2)
        .transition(.opacity.combined(with: .offset(y: -4)))
    }
}
