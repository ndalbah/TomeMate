//
//  TomeFilterBar.swift
//  TomeMate
//

import SwiftUI

// MARK: - Filter chip model

struct TomeFilterChip: Identifiable {
    let id: String
    let label: String
}

// MARK: - Filter bar

struct TomeFilterBar<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                content()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
        .background(Color.tomeParchment.opacity(0.18))
        .overlay(
            Rectangle()
                .fill(Color.tomeSepia.opacity(0.2))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

// MARK: - Chip group
struct TomeChipGroup<T: Hashable>: View {
    let title: String
    let options: [T]
    let label: (T) -> String
    @Binding var selection: T?

    var body: some View {
        HStack(spacing: 6) {
            Text(title.uppercased())
                .font(.custom("Cinzel-Regular", size: 8))
                .tracking(1.5)
                .foregroundStyle(Color.tomeSepia)

            ForEach(options, id: \.self) { option in
                let isActive = selection == option
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        selection = isActive ? nil : option
                    }
                } label: {
                    Text(label(option))
                        .font(.custom("IMFellEnglish-Regular", size: 11))
                        .foregroundStyle(isActive ? Color.tomeParchment : Color.tomeInk)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isActive ? Color.tomeCrimson : Color.tomeParchment.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(
                                    isActive ? Color.tomeCrimson : Color.tomeSepia.opacity(0.35),
                                    lineWidth: 0.8
                                )
                        )
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.15), value: isActive)
            }
        }
    }
}

// MARK: - Bool toggle chip (e.g. Concentration / Magic)

struct TomeBoolChip: View {
    let trueLabel: String
    let falseLabel: String
    @Binding var selection: Bool?

    var body: some View {
        HStack(spacing: 6) {
            chipButton(label: trueLabel, value: true)
            chipButton(label: falseLabel, value: false)
        }
    }

    private func chipButton(label: String, value: Bool) -> some View {
        let isActive = selection == value
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                selection = isActive ? nil : value
            }
        } label: {
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .foregroundStyle(isActive ? Color.tomeParchment : Color.tomeInk)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(isActive ? Color.tomeCrimson : Color.tomeParchment.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(
                            isActive ? Color.tomeCrimson : Color.tomeSepia.opacity(0.35),
                            lineWidth: 0.8
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Clear filters button

struct TomeClearFiltersButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                Text("Clear")
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(1)
            }
            .foregroundStyle(Color.tomeCrimson)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Color.tomeCrimson.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .strokeBorder(Color.tomeCrimson.opacity(0.3), lineWidth: 0.8)
            )
            .cornerRadius(2)
        }
        .buttonStyle(.plain)
    }
}
