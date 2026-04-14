//
//  Page10.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import SwiftUI

struct ExperienceView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State var isXP : Bool = false
    @State var isMilestone: Bool = false
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            
            VStack(spacing: 28) {
                Spacer()
                
                Text("How do you level up?")
                    .font(.custom("Cinzel-Bold", size: 24))
                    .tracking(2)
                    .foregroundStyle(Color.tomeGold)
                    .multilineTextAlignment(.center)
                
                TomeDecorativeRule().frame(maxWidth: 220)
                
                VStack(spacing: 14) {
                    TomeOptionCard(title: "Experience Points",
                                   subtitle: "Earn XP through deeds and battles",
                                   icon: "star.fill",
                                   isSelected: isXP) { isXP = true }
                    TomeOptionCard(title: "Milestone",
                                   subtitle: "Level at the DM's discretion",
                                   icon: "flag.fill",
                                   isSelected: isMilestone) { isMilestone = true }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private struct TomeOptionCard: View {
        let title: String
        let subtitle: String
        let icon: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .foregroundStyle(isSelected ? Color.tomeCrimson : Color.tomeSepia)
                        .font(.system(size: 16))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.custom("Cinzel-Regular", size: 12))
                            .tracking(1)
                            .foregroundStyle(Color.tomeInk)
                        Text(subtitle)
                            .font(.custom("IMFellEnglish-Italic", size: 11))
                            .foregroundStyle(Color.tomeSepia)
                    }
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.tomeCrimson)
                            .font(.system(size: 12, weight: .bold))
                    }
                }
                .padding(14)
                .background(isSelected ? Color.tomeParchmentMid : Color.tomeParchmentLight)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(isSelected ? Color.tomeCrimson : Color.tomeSepia.opacity(0.35), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
   // Page10()
}
