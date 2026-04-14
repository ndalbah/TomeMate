//
//  Page2.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct AgeView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State private var ageText: String = ""
    
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Spacer()

                Text("How old art thou,")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)

                Text("Adventurer?")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                TomeTextField(
                    label: "Age",
                    icon: "number",
                    placeholder: "Enter your age",
                    text: $ageText,
                )
                .keyboardType(.numberPad)
                .padding(.horizontal, 32)

                Spacer()
            }
        }
        .onChange(of: ageText) {
            newValue in
            isDisabled = newValue.trimmingCharacters(in: .whitespaces).isEmpty
            
            if let age = Int(ageText), age > 0 {
                formData.age = age
                isDisabled = false
            } else {
                formData.age = 0
                isDisabled = true
            }
        }
        .onAppear {
            isDisabled = formData.age == 0
            if formData.age == 0 {
                isDisabled = true
            }
            else{
                ageText = String(formData.age)
                isDisabled = false
            }
        }
    }
}

#Preview {

}
