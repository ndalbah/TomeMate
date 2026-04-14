//
//  Page6.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//
import SwiftUI

struct StatsView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool

    @State private var strvalue: Double = 10
    @State private var dexvalue: Double = 10
    @State private var convalue: Double = 10
    @State private var wisvalue: Double = 10
    @State private var intvalue: Double = 10
    @State private var chavalue: Double = 10

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {

                // MARK: Header
                Text("Forge your Soul")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)

                Text("Ability Scores")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                // MARK: Sliders
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ThemedStatRow(label: "Strength", abbreviation: "STR", value: $strvalue)
                        ThemedStatRow(label: "Dexterity", abbreviation: "DEX", value: $dexvalue)
                        ThemedStatRow(label: "Constitution", abbreviation: "CON", value: $convalue)
                        ThemedStatRow(label: "Intelligence", abbreviation: "INT", value: $intvalue)
                        ThemedStatRow(label: "Wisdom", abbreviation: "WIS", value: $wisvalue)
                        ThemedStatRow(label: "Charisma", abbreviation: "CHA", value: $chavalue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            isDisabled = false
            if formData.strength != 10 { strvalue = Double(formData.strength) }
            if formData.dexterity != 10 { dexvalue = Double(formData.dexterity) }
            if formData.constitution != 10 { convalue = Double(formData.constitution) }
            if formData.intelligence != 10 { intvalue = Double(formData.intelligence) }
            if formData.wisdom != 10 { wisvalue = Double(formData.wisdom) }
            if formData.charisma != 10 { chavalue = Double(formData.charisma) }
        }
        .onDisappear {
            formData.strength = Int(strvalue)
            formData.dexterity = Int(dexvalue)
            formData.constitution = Int(convalue)
            formData.intelligence = Int(intvalue)
            formData.wisdom = Int(wisvalue)
            formData.charisma = Int(chavalue)
        }
    }
}

// MARK: - Stat Row

private struct ThemedStatRow: View {
    let label: String
    let abbreviation: String
    @Binding var value: Double

    private var modifier: Int {
        Int(floor((value - 10) / 2))
    }

    private var modifierText: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }

    // Colour-codes the modifier: gold for positive, sepia for zero, crimson for negative
    private var modifierColor: Color {
        if modifier > 0 { return Color.tomeGold }
        if modifier < 0 { return Color.tomeCrimson }
        return Color.tomeSepia
    }

    var body: some View {
        HStack(spacing: 12) {

            // Stat score bubble
            ZStack {
                Circle()
                    .fill(Color.tomeParchmentMid)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.tomeSepia.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                    .frame(width: 52, height: 52)

                VStack(spacing: 0) {
                    Text("\(Int(value))")
                        .font(.custom("Cinzel-Bold", size: 16))
                        .foregroundStyle(Color.tomeInk)
                    Text(modifierText)
                        .font(.custom("IMFellEnglish-Regular", size: 11))
                        .foregroundStyle(modifierColor)
                }
            }

            // Label + slider
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(abbreviation)
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(1.5)
                        .foregroundStyle(Color.tomeSepia)
                    Text(label)
                        .font(.custom("IMFellEnglish-Regular", size: 14))
                        .foregroundStyle(Color.tomeParchment)
                }

                // Custom-tinted slider
                Slider(value: $value, in: 0...20, step: 1) {
                    Text(label)
                } minimumValueLabel: {
                    Text("0")
                        .font(.custom("Cinzel-Regular", size: 9))
                        .foregroundStyle(Color.tomeSepia)
                } maximumValueLabel: {
                    Text("20")
                        .font(.custom("Cinzel-Regular", size: 9))
                        .foregroundStyle(Color.tomeSepia)
                }
                .tint(Color.tomeCrimson)
                .onChange(of: value) { newValue in
                    value = Double(Int(newValue.rounded()))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.tomeParchmentLight.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(Color.tomeSepia.opacity(0.25), lineWidth: 1)
                )
        )
    }
}
