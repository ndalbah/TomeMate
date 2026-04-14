//
//  Page9.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//
import SwiftUI

struct LanguageView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = LanguageViewModel()
    @State var languages: [LanguageModel] = []
    @State var manualSelections: Set<String> = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    func isGranted(_ language: LanguageModel) -> Bool {
        let name = language.name.lowercased().trimmingCharacters(in: .whitespaces)
        let fromRace = formData.race.languages
            .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
            .contains(name)
        let fromSubrace = formData.subrace?.languages
            .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
            .contains(name) ?? false
        return fromRace || fromSubrace
    }

    func isProficient(_ language: LanguageModel) -> Bool {
        manualSelections.contains(language.name) || isGranted(language)
    }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Text("Tongues you have mastered")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)

                Text("Languages")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(languages) { language in
                            ThemedLanguageCard(
                                language: language,
                                isProficient: isProficient(language),
                                isGranted: isGranted(language)
                            ) {
                                if !isGranted(language) {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        if manualSelections.contains(language.name) {
                                            manualSelections.remove(language.name)
                                        } else {
                                            manualSelections.insert(language.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .onDisappear {
            formData.languages = languages.filter { isProficient($0) }
        }
        .onAppear {
            isDisabled = false
            viewModel.fetchLanguages()  // always fetch so viewModel.languages is populated
            if !formData.languages.isEmpty {
                languages = viewModel.languages
                manualSelections = Set(
                    formData.languages
                        .filter { !isGranted($0) }
                        .map { $0.name }
                )
            }
        }
        .onChange(of: viewModel.languages) { newLanguages in
            languages = newLanguages
        }
        .onChange(of: formData.race.languages) { _ in
            manualSelections.removeAll()
            formData.languages.removeAll()
            languages = viewModel.languages
            
        }
        .onChange(of: formData.subrace?.languages) { _ in
            manualSelections.removeAll()
            formData.languages.removeAll()
            languages = viewModel.languages
        }
    }
}

private struct ThemedLanguageCard: View {
    let language: LanguageModel
    let isProficient: Bool
    let isGranted: Bool
    let onTap: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isProficient ? Color.tomeParchmentMid : Color.tomeParchmentLight)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(
                        isProficient ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4),
                        lineWidth: isProficient ? 1.5 : 1
                    )
            )
            .shadow(color: .black.opacity(isProficient ? 0.25 : 0.1), radius: isProficient ? 6 : 3, y: 2)
            .overlay {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(language.name)
                            .font(.custom("Cinzel-Regular", size: 11))
                            .tracking(1)
                            .foregroundStyle(Color.tomeInk)
                        if isGranted {
                            Text("granted")
                                .font(.custom("IMFellEnglish-Italic", size: 9))
                                .foregroundStyle(Color.tomeSepia)
                        }
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .strokeBorder(Color.tomeSepia.opacity(0.5), lineWidth: 1)
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(Color.tomeCrimson)
                            .frame(width: 20, height: 20)
                            .scaleEffect(isProficient ? 1 : 0)
                            .animation(.spring(response: 0.3), value: isProficient)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .frame(height: 50)
            .onTapGesture { onTap() }
    }
}

