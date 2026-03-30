//
//  LevelUpView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct LevelUpView: View {
    let character: Character
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder

    @State private var selectedClass: Classes? = nil
    @State private var appeared = false

    private var classes: [Classes] {
        let set = character.classes as? Set<Classes> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    private var newLevel: Int16 {
        character.level + 1
    }

    private var profBonusIncreases: Bool {
        let level = Int(newLevel)
        return [5, 9, 13, 17].contains(level)
    }

    private var hpIncrease: Int16 {
        guard let cls = selectedClass else { return 0 }
        let newHp = holder.calculateNewHp(character: character, selectedClass: cls)
        let newHpInt16 = Int16(newHp)
        return newHpInt16 - character.hp
    }

    private var newHpTotal: Int16 {
        character.hp + hpIncrease
    }

    private var newProfBonus: Int16 {
        character.proficiencyBonus + 1
    }

    private var selectedClassName: String {
        selectedClass?.name ?? "Class"
    }

    private var selectedClassLevel: Int32 {
        selectedClass?.level ?? 0
    }

    private var newClassLevel: Int32 {
        selectedClassLevel + 1
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    heroBanner
                    classSelector
                    if selectedClass != nil {
                        changesSection
                    }
                    confirmButton
                }
                .padding(16)
                .animation(.spring(response: 0.35), value: selectedClass)
            }
        }
        .navigationTitle("Level Up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MultiClassView(character: character)
                        .onDisappear {
                            dismiss()
                        }
                } label: {
                    Label("Multiclass", systemImage: "plus.circle.fill")
                        .foregroundStyle(.purple)
                }
            }
        }
        .onAppear {
            appeared = true
            if classes.count == 1 {
                selectedClass = classes.first
            }
        }
    }

    // MARK: - Hero Banner
    private var heroBanner: some View {
        VStack(spacing: 6) {
            Text("⬆︎")
                .font(.system(size: 44))
            Text("Level Up")
                .font(.system(size: 32, weight: .bold, design: .serif))
            Text(character.name ?? "Unknown")
                .font(.headline)
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                Text("Level \(character.level)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Level \(newLevel)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Class Selector
    private var classSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Which class levels up?", systemImage: "shield.lefthalf.filled")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.8)

            VStack(spacing: 8) {
                ForEach(classes, id: \.self) { cls in
                    classRow(cls)
                }
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func classRow(_ cls: Classes) -> some View {
        let isSelected = selectedClass == cls
        let fillColor: Color = isSelected ? Color.blue.opacity(0.08) : Color(.secondarySystemGroupedBackground)
        let strokeColor: Color = isSelected ? Color.blue.opacity(0.4) : .clear
        let checkIcon = isSelected ? "checkmark.circle.fill" : "circle"
        let checkColor: Color = isSelected ? .blue : .secondary

        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedClass = cls
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(cls.name ?? "Unknown")
                        .font(.system(.body, design: .serif))
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("Currently level \(cls.level)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: checkIcon)
                    .font(.title3)
                    .foregroundStyle(checkColor)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(fillColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(strokeColor, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Changes Section
    private var changesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("New Changes", systemImage: "sparkles")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.8)

            VStack(spacing: 0) {
                ChangeRow(
                    icon: "arrow.up.circle.fill",
                    iconColor: .blue,
                    label: "Character Level",
                    from: "\(character.level)",
                    to: "\(newLevel)"
                )

                Divider().padding(.leading, 44)

                ChangeRow(
                    icon: "shield.fill",
                    iconColor: .indigo,
                    label: "\(selectedClassName) Level",
                    from: "\(selectedClassLevel)",
                    to: "\(newClassLevel)"
                )

                Divider().padding(.leading, 44)

                ChangeRow(
                    icon: "heart.fill",
                    iconColor: .red,
                    label: "Hit Points",
                    from: "\(character.hp)",
                    to: "\(newHpTotal)",
                    delta: hpIncrease > 0 ? "+\(hpIncrease)" : "\(hpIncrease)"
                )

                if profBonusIncreases {
                    Divider().padding(.leading, 44)
                    ChangeRow(
                        icon: "star.fill",
                        iconColor: .orange,
                        label: "Proficiency Bonus",
                        from: "+\(character.proficiencyBonus)",
                        to: "+\(newProfBonus)",
                        delta: "+1"
                    )
                }
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    // MARK: - Confirm Button
    private var confirmButton: some View {
        let isDisabled = selectedClass == nil
        let bgColor: Color = isDisabled ? Color(.systemGray4) : Color.blue

        return Button {
            guard let cls = selectedClass else { return }
            holder.levelUp(character: character, selectedClass: cls, context)
            dismiss()
        } label: {
            Label("Confirm Level Up", systemImage: "arrow.up.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(bgColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isDisabled)
    }
}

// MARK: - ChangeRow
private struct ChangeRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let from: String
    let to: String
    var delta: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.system(size: 18))
                .frame(width: 28)

            Text(label)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()

            HStack(spacing: 6) {
                Text(from)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(to)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if let delta {
                    Text(delta)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
}
