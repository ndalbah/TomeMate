//
//  TomeLookupComponents.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct TomeSearchBar: View {
    let placeholder: String
    @Binding var text: String
    @FocusState private var focused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .light))
                .foregroundStyle(focused ? Color.tomeCrimson : Color.tomeSepia)
                .animation(.easeInOut(duration: 0.2), value: focused)
            
            ZStack(alignment: .bottom) {
                TextField(placeholder, text: $text)
                    .font(.custom("IMFellEnglish-Regular", size: 15))
                    .foregroundStyle(Color.tomeInk)
                    .focused($focused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 6)
                Rectangle()
                    .fill(focused ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4))
                    .frame(height: focused ? 1.5 : 1)
                    .animation(.easeInOut(duration: 0.2), value: focused)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.tomeParchment.opacity(0.55))
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(focused ? Color.tomeCrimson.opacity(0.5) : Color.tomeSepia.opacity(0.3), lineWidth: 1
            )
            .animation(.easeInOut(duration: 0.2), value: focused)
        )
        .cornerRadius(3)
    }
}

struct TomeListRow: View {
    let title: String
    let subtitle: String
    var badge: String? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(Color.tomeCrimson.opacity(0.6))
                .frame(width: 2)
                .cornerRadius(1)
                .padding(.vertical, 3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Cinzel-Regular", size: 13))
                    .foregroundStyle(Color.tomeInk)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.custom("IMFellEnglish-Regular", size: 12))
                    .italic()
                    .foregroundStyle(Color.tomeSepia)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if let badge {
                Text(badge)
                    .font(.custom("Cinzel-Bold", size: 11))
                    .tracking(1)
                    .foregroundStyle(Color.tomeGold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.tomeInk.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .strokeBorder(Color.tomeGoldDim.opacity(0.5), lineWidth: 0.8)
                    )
                    .cornerRadius(2)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}

struct TomePagnationSpinner: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 6) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.tomeGold))
                    .scaleEffect(0.85)
                Text("Turning the page...")
                    .font(.custom("IMFellEnglish-Regular", size: 10))
                    .italic()
                    .foregroundStyle(Color.tomeSepia)
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct TomeEmptyStateView: View {
    let message: String
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "book.closed")
                .font(.system(size: 36, weight: .ultraLight))
                .foregroundStyle(Color.tomeSepia.opacity(0.45))
            
            Text(message)
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .italic()
                .foregroundStyle(Color.tomeSepia.opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 70)
    }
}

struct TomeLoadingView: View {
    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.tomeGold))
            Text("Searching the archives...")
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .italic()
                .foregroundStyle(Color.tomeSepia)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 70)
    }
}

struct TomeLookupErrorView: View {
    let message: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeCrimson)
            Text(message)
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeCrimson)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tomeCrimson.opacity(0.07))
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(Color.tomeCrimson.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(3)
    }
}
