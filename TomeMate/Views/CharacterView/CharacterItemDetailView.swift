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
                            .font(.custom("Cinzel-Regular", size: 35))
                            .foregroundStyle(Color.tomeInk)
                        Text(item.type ?? "")
                            .font(.custom("IMFellEnglish-Regular", size: 20))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        Text(item.rarity ?? "")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .tracking(1.5)
                            .foregroundStyle(Color.tomeGold)
                    }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    if let desc = item.desc, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Cinzel-Regular", size: 30))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }
                    
                    if item.isMagic {
                        DecorativeRuleView()
                        typeSpecificSection(for: item)
                            .fadeUp(appeared, delay: 0.15)
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
    
    @ViewBuilder
    private func typeSpecificSection(for item: Item) -> some View {
        let type = item.type?.lowercased() ?? ""

        // Weapon types
        if ["ranged weapon", "melee weapon"].contains(type) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Weapon")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                if let bonus = item.bonusWeapon, !bonus.isEmpty {
                    DetailRow(label: "Attack Bonus", value: "\(bonus)")
                }
                if item.weight != 0 {
                    DetailRow(label: "Weight", value: "\(item.weight) lbs")
                }
                if item.value != 0 {
                    DetailRow(label: "Value", value: "\(item.value) gp")
                }
            }

        // Armor types
        } else if ["light armor", "medium armor", "heavy armor"].contains(type) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Armor")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                if let bonus = item.bonusAc, !bonus.isEmpty {
                    DetailRow(label: "AC Bonus", value: "\(bonus)")
                }
                if item.weight != 0 {
                    DetailRow(label: "Weight", value: "\(item.weight) lbs")
                }
            }

        // Wondrous / magical focus
        } else if item.wondrous {
            VStack(alignment: .leading, spacing: 8) {
                Text("Magical Properties")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                if let spellAtk = item.bonusSpellAttack, !spellAtk.isEmpty {
                    DetailRow(label: "Spell Attack", value: "\(spellAtk)")
                }
                if let spellDc = item.bonusSpellSaveDc, !spellDc.isEmpty {
                    DetailRow(label: "Spell Save DC", value: "\(spellDc)")
                }
            }
        }

        if item.reqAttune {
            DetailRow(label: "Attunement", value: "Required")
        }
    }

    private struct DetailRow: View {
        let label: String
        let value: String
        var body: some View {
            HStack {
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 20))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeMuted)
                Spacer()
                Text(value)
                    .font(.custom("IMFellEnglish-Regular", size: 23))
                    .foregroundStyle(Color.tomeParchmentLight)
            }
        }
    }
}

#Preview {
 //   CharacterItemDetailView(item: Item())
}
