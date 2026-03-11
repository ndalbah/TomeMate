//
//  SpellDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct SpellDetailView: View {
    let spell: SpellModel
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
                        Text(spell.name)
                            .font(.custom("Cinzel-Regular", size: 26))
                            .foregroundStyle(Color.tomeInk)
                        Text("Level \(spell.level) • \(spell.school)")
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        Text("Cast Time: \(spell.cast_time)")
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                                        }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.custom("Cinzel-Regular", size: 11))
                            .tracking(2)
                            .foregroundStyle(Color.tomeCrimson)
                        Text(spell.description)
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .foregroundStyle(Color.tomeSepia)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .fadeUp(appeared, delay: 0.1)

                    DecorativeRuleView()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Damage & Save")
                            .font(.custom("Cinzel-Regular", size: 11))
                            .tracking(2)
                            .foregroundStyle(Color.tomeCrimson)

                    if let damageType = spell.damage_type, !damageType.isEmpty {
                        SpellDetailRow(label: "Damage Type", value: damageType)
                    }
                    if let saveType = spell.saving_throw_type, !saveType.isEmpty {
                        SpellDetailRow(label: "Saving Throw", value: saveType)
                    }
                    if let conditions = spell.condition_type, !conditions.isEmpty {
                        SpellDetailRow(label: "Condition", value: conditions.joined(separator: ", "))
                    }
                }
                .fadeUp(appeared, delay: 0.15)
            }
            .padding(24)
        }
    }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}


private struct SpellDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .font(.custom("Cinzel-Regular", size: 10))
                .tracking(0.5)
                .foregroundStyle(Color.tomeInk)
            Text(value)
                .font(.custom("IMFellEnglish-Regular", size: 12))
                .italic()
                .foregroundStyle(Color.tomeSepia)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    //SpellDetailView()
}
