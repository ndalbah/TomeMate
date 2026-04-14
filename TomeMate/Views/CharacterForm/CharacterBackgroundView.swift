//
//  Page4.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import SwiftUI

struct CharacterBackgroundView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = BackgroundViewModel()
    @State private var selectedBackground: BackgroundModel? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Text("Choose your Background")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)

                Text("Background")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.backgrounds) { background in
                            ThemedBackgroundCard(
                                background: background,
                                isSelected: selectedBackground == background
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedBackground = background
                                    formData.background = background
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear{
            selectedBackground = formData.background
            if selectedBackground?.name == "" {
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .onChange(of: formData.background){
            isDisabled = false
        }
    }
}

private struct ThemedBackgroundCard: View {
    let background: BackgroundModel
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isSelected ? Color.tomeParchmentMid : Color.tomeParchmentLight)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(
                        isSelected ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(color: .black.opacity(isSelected ? 0.3 : 0.15), radius: isSelected ? 8 : 4, y: 3)
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(background.name)
                        .font(.custom("Cinzel-Regular", size: 11))
                        .tracking(1)
                        .foregroundStyle(Color.tomeInk)
                        .multilineTextAlignment(.center)
                    Text(background.skillProficiencies.joined(separator: " / "))
                        .font(.custom("IMFellEnglish-Regular", size: 10))
                        .foregroundStyle(Color.tomeSepia)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(8)
            }
            .frame(height: 90)
    }
}

#Preview {
   // Page4()
}
