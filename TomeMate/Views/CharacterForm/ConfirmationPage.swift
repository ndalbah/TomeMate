//
//  ConfirmationPage.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-02.
//

import SwiftUI

struct ConfirmationPage: View {
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Spacer()
                TomeEmblemView().frame(width: 80, height: 80)
                    .padding(.bottom, 20)

                Text("Your legend is written.")
                    .font(.custom("IMFellEnglish-Italic", size: 14))
                    .foregroundStyle(Color.tomeSepia)

                Text("Character Complete")
                    .font(.custom("Cinzel-Bold", size: 26))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 12)
                    .padding(.top, 6)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                Text("Are you ready to begin your adventure?")
                    .font(.custom("IMFellEnglish-Regular", size: 13))
                    .foregroundStyle(Color.tomeParchmentText)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    //ConfirmationPage()
}
