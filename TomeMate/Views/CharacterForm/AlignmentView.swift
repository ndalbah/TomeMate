//
//  Page7.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import SwiftUI

struct AlignmentView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State private var alignmentValue1: Double = 1
    @State private var alignmentValue2: Double = 1
    var alignmentText1: String {
        switch Int(alignmentValue1){
        case 0: return "Good"
        case 1: return "Neutral"
        case 2: return "Evil"
        default: return ""
        }
    }
    var alignmentText2: String {
        switch Int(alignmentValue2){
        case 0: return "Lawful"
        case 1: return "Neutral"
        case 2: return "Chaotic"
        default: return ""
        }
    }
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Text("What is your Alignment?")
                    .font(.custom("Cinzel-Bold", size: 24))
                    .tracking(2)
                    .foregroundStyle(Color.tomeGold)
                    .multilineTextAlignment(.center)
                
                TomeDecorativeRule().frame(maxWidth: 220)
                
                // Slider card
                VStack(spacing: 24) {
                    TomeAlignmentSlider(value: $alignmentValue1,
                                        current: alignmentText1,
                                        low: "Good", high: "Evil")
                    Divider().background(Color.tomeSepia.opacity(0.3))
                    TomeAlignmentSlider(value: $alignmentValue2,
                                        current: alignmentText2,
                                        low: "Lawful", high: "Chaotic")
                }
                .padding(20)
                .background(Color.tomeParchmentLight)
                .cornerRadius(3)
                .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private struct TomeAlignmentSlider: View {
        @Binding var value: Double
        let current: String
        let low: String
        let high: String
        
        var body: some View {
            VStack(spacing: 8) {
                Text(current)
                    .font(.custom("Cinzel-SemiBold", size: 13))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                
                HStack {
                    Text(low)
                        .font(.custom("IMFellEnglish-Regular", size: 11))
                        .foregroundStyle(Color.tomeSepia)
                    Slider(value: $value, in: 0...2, step: 1)
                        .tint(Color.tomeCrimson)
                    Text(high)
                        .font(.custom("IMFellEnglish-Regular", size: 11))
                        .foregroundStyle(Color.tomeSepia)
                }
            }
        }
    }
}

#Preview {
//    Page7()
}
