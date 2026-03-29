//
//  ChangeLanguagesView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct ChangeLanguagesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character
    @StateObject var viewModel = LanguageViewModel()
    @State var languages: [LanguageModel] = []
    @State var manualSelections: Set<String> = []
    @State private var grantedLanguages: Set<String> = [] // frozen on appear, never changes
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    func isGranted(_ language: LanguageModel) -> Bool {
        grantedLanguages.contains(language.name)
    }

    func isProficient(_ language: LanguageModel) -> Bool {
        manualSelections.contains(language.name) || isGranted(language)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Select your Languages")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 10)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(languages) { language in
                            LanguageCard(
                                language: language,
                                isProficient: isProficient(language),
                                isLocked: isGranted(language)
                            ) {
                                if isGranted(language) { return }
                                if manualSelections.contains(language.name) {
                                    manualSelections.remove(language.name)
                                } else {
                                    manualSelections.insert(language.name)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 90)
                }
            }

            Button {
                let selected = languages.filter { isProficient($0) }
                holder.updateLanguage(character: character, languages: selected, context)
                dismiss()
            } label: {
                Text("Save Languages")
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
        .onAppear {
            viewModel.fetchLanguages()
            manualSelections = Set(character.languages ?? [])
            grantedLanguages = [] // nothing is permanently locked — all are editable
        }
        .onChange(of: viewModel.languages) { newLanguages in
            languages = newLanguages
        }
    }
}

private struct LanguageCard: View {
    let language: LanguageModel
    let isProficient: Bool
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(language.name)
            Spacer()
            ZStack {
                Circle()
                    .strokeBorder(isLocked ? Color.gray.opacity(0.4) : Color.gray, lineWidth: 1)
                    .frame(width: 20, height: 20)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isLocked ? Color.blue.opacity(0.4) : Color.blue)
                    .scaleEffect(isProficient ? 1 : 0)
            }
        }
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}
