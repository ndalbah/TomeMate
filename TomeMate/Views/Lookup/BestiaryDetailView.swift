//
//  BestiaryDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct BestiaryDetailView: View {
    let creature: CreatureModel
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            Color.tomeBg
                .ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(creature.name)
                            .font(.custom("Cinzel-Regular", size: 26))
                            .foregroundStyle(Color.tomeInk)
                        Text("\(creature.size) \(creature.type)")
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        Text(creature.alignment)
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                    }
                    .fadeUp(appeared, delay: 0.05)
                    
                    DecorativeRuleView()
                    
                    HStack(spacing: 0) {
                        BestiaryStatPill(label: "HP", value: "\(creature.hit_points)")
                        BestiaryStatPill(label: "AC", value: "\(creature.armor_class)")
                        BestiaryStatPill(label: "CR", value: "\(creature.challenge_rating)")
                    }
                    .fadeUp(appeared, delay: 0.1)
                }
                .padding(24)
            }
        }
        .navigationTitle(creature.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}

private struct BestiaryStatPill: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("Cinzel-Regular", size: 13))
                .foregroundStyle(Color.tomeInk)
            Text(label)
                .font(.custom("Cinzel-Regular", size: 8))
                .tracking(1.5)
                .foregroundStyle(Color.tomeSepia)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.tomeParchment.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Color.tomeSepia.opacity(0.2), lineWidth: 0.8)
        )
        .cornerRadius(2)
        .padding(2)
    }
}

#Preview {
    NavigationStack {
        BestiaryDetailView(creature: CreatureModel(
            id: "1",
            name: "Aboleth",
            size: "Large",
            type: "aberration",
            alignment: "lawful evil",
            armor_class: 17,
            hit_points: 135,
            challenge_rating: "10"
        ))
    }
}
