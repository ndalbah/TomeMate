//
//  CharacterItemDetailView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-22.
//
import SwiftUI

struct CharacterItemDetailView: View {
    let item: Item
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.tomeBg
                .ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name ?? "")
                            .font(.custom("Cinzel-Regular", size: 26))
                            .foregroundStyle(Color.tomeInk)
                        Text(item.type ?? "")
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        Text(item.rarity ?? "")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .tracking(1.5)
                            .foregroundStyle(Color.tomeGold)
                    }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    if let desc = item.desc, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 13))
                                .foregroundStyle(Color.tomeSepia)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle(item.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}

#Preview {
 //   CharacterItemDetailView(item: Item())
}
