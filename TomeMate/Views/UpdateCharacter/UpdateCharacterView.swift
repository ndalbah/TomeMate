//
//  UpdateCharacterView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct UpdateCharacterView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder

    let character: Character

    @State private var gold: Double
    @State private var inspiration: Double
    @State private var hitpoints: Double
    @State private var armorClass: Double
    @State private var speed: Double
    @State private var experience: Double
    @State private var age: Double
    @State private var initiative: Double
    @State private var passivePerception: Double
    @State private var alignment: String

    let alignments = [
        "Lawful Good", "Neutral Good", "Chaotic Good",
        "Lawful Neutral", "True Neutral", "Chaotic Neutral",
        "Lawful Evil", "Neutral Evil", "Chaotic Evil"
    ]

    init(character: Character) {
        self.character = character
        _gold              = State(initialValue: Double(character.gold))
        _inspiration       = State(initialValue: Double(character.inspiration))
        _hitpoints         = State(initialValue: Double(character.hp))
        _armorClass        = State(initialValue: Double(character.armorClass))
        _speed             = State(initialValue: Double(character.speed ?? "30") ?? 30)
        _experience        = State(initialValue: Double(character.experiencePoints))
        _age               = State(initialValue: Double(character.age))
        _initiative        = State(initialValue: Double(character.initiative))
        _passivePerception = State(initialValue: Double(character.passivePerception))
        _alignment         = State(initialValue: character.alignment ?? "True Neutral")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 6) {
                    Text("Edit Character")
                        .font(.title)
                        .bold()
                        .padding(.vertical, 10)

                    // MARK: - Combat
                    SectionHeader(title: "Combat")
                    StatRow(label: "Hit Points",value: $hitpoints, range: 0...999)
                    StatRow(label: "Armor Class",value: $armorClass,range: 0...30)
                    StatRow(label: "Initiative",value: $initiative,range: -10...20)
                    StatRow(label: "Speed", value: $speed, range: 0...120, step: 5)
                    StatRow(label: "Passive Perception", value: $passivePerception, range: 0...30)

                    Divider().padding(.vertical, 8)

                    // MARK: - Character Info
                    SectionHeader(title: "Character Info")
                    StatRow(label: "Inspiration", value: $inspiration, range: 0...999)
                    StatRow(label: "Age",value: $age, range: 0...999)
                    GoldRow(label: "Gold",value: $gold)
                    if character.useXp {
                        XpRow(label: "Experience", value: $experience)
                    }

                    Divider().padding(.vertical, 8)

                    // MARK: - Alignment
                    SectionHeader(title: "Alignment")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(alignments, id: \.self) { option in
                            Button {
                                alignment = option
                            } label: {
                                Text(option)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(alignment == option ? Color.accentColor.opacity(0.15) : Color.primary.opacity(0.05))
                                    .foregroundColor(alignment == option ? .accentColor : .primary)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(alignment == option ? Color.accentColor : Color.clear, lineWidth: 1.5)
                                    )
                            }
                        }
                    }
                    .padding(.bottom, 90)
                }
                .padding()
            }

            Button {
                holder.updateCharacter(
                    character: character,
                    gold: gold,
                    inspiration: inspiration,
                    hitpoints: hitpoints,
                    armor_class: armorClass,
                    speed: speed,
                    experience: experience,
                    age: age,
                    initiative: initiative,
                    passive_perception: passivePerception,
                    alignement: alignment,
                    context
                )
                dismiss()
            } label: {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            )
        }
    }
}

// MARK: - Section Header
private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.footnote)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .kerning(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

// MARK: - Regular Stat Row
private struct StatRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 1

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            HStack(spacing: 12) {
                Button {
                    if value - step >= range.lowerBound { value -= step }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                Text("\(Int(value))")
                    .font(.headline)
                    .frame(minWidth: 40)
                    .multilineTextAlignment(.center)
                Button {
                    if value + step <= range.upperBound { value += step }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.primary.opacity(0.04))
        .cornerRadius(12)
    }
}

// MARK: - Gold Row (step 1, 10, 100)
private struct GoldRow: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(value)) gp")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 8) {
                StepButton(label: "-100", color: .red)   { value = max(0, value - 100) }
                StepButton(label: "-10",  color: .red)   { value = max(0, value - 10)  }
                StepButton(label: "-1",   color: .red)   { value = max(0, value - 1)   }
                Spacer()
                StepButton(label: "+1",   color: .green) { value += 1   }
                StepButton(label: "+10",  color: .green) { value += 10  }
                StepButton(label: "+100", color: .green) { value += 100 }
            }
        }
        .padding()
        .background(Color.primary.opacity(0.04))
        .cornerRadius(12)
    }
}

// MARK: - XP Row (step 1, 100, 1000)
private struct XpRow: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(value)) XP")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 8) {
                StepButton(label: "-1000", color: .red)   { value = max(0, value - 1000) }
                StepButton(label: "-100",  color: .red)   { value = max(0, value - 100)  }
                StepButton(label: "-1",    color: .red)   { value = max(0, value - 1)    }
                Spacer()
                StepButton(label: "+1",    color: .green) { value += 1    }
                StepButton(label: "+100",  color: .green) { value += 100  }
                StepButton(label: "+1000", color: .green) { value += 1000 }
            }
        }
        .padding()
        .background(Color.primary.opacity(0.04))
        .cornerRadius(12)
    }
}

// MARK: - Step Button helper
private struct StepButton: View {
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color.opacity(0.12))
                .foregroundColor(color)
                .cornerRadius(8)
        }
    }
}

#Preview {
    // UpdateCharacterStatsView(character: ...)
}
