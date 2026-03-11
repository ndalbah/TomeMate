//
//  ItemDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct ItemDetailView: View {
    let item: ItemModel
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
                        Text(item.name)
                            .font(.custom("Cinzel-Regular", size: 26))
                            .foregroundStyle(Color.tomeInk)
                        Text(item.type)
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        Text(item.rarity)
                            .font(.custom("Cinzel-Regular", size: 10))
                            .tracking(1.5)
                            .foregroundStyle(Color.tomeGold)
                    }
                    .fadeUp(appeared, delay: 0.05)
                    
                    DecorativeRuleView()
                    
                    // Description
                    if !item.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(item.description)
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
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: ItemModel(
            id: "1",
            name: "Longsword",
            type: "Weapon",
            rarity: "Common",
            description: "A standard longsword.",
            isMagic: false
        ))
    }
}
