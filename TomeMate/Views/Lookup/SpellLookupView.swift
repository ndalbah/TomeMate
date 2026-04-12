//
//  SpellLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct SpellLookupView: View {
    @StateObject private var viewModel = SpellLookupViewModel()

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                TomeSearchBar(placeholder: "Seek a spell...", text: $viewModel.searchText)
                    .padding(.horizontal, 14)
                    .padding(.top, 14)
                    .padding(.bottom, 8)

                if !viewModel.allSpells.isEmpty {
                    TomeFilterBar {
                        if viewModel.hasActiveFilters {
                            TomeClearFiltersButton { viewModel.clearFilters() }
                        }
                        if !viewModel.levelOptions.isEmpty {
                            TomeChipGroup(
                                title: "Level",
                                options: viewModel.levelOptions,
                                label: { $0 == 0 ? "Cantrip" : "Lvl \($0)" },
                                selection: $viewModel.selectedLevel
                            )
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        if !viewModel.schoolOptions.isEmpty {
                            TomeChipGroup(title: "School", options: viewModel.schoolOptions, label: { $0 }, selection: $viewModel.selectedSchool)
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        HStack(spacing: 6) {
                            Text("CONC.")
                                .font(.custom("Cinzel-Regular", size: 8))
                                .tracking(1.5)
                                .foregroundStyle(Color.tomeSepia)
                            TomeBoolChip(trueLabel: "Yes", falseLabel: "No", selection: $viewModel.selectedConcentration)
                        }
                        if !viewModel.damageTypeOptions.isEmpty {
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                            TomeChipGroup(title: "Damage", options: viewModel.damageTypeOptions, label: { $0.capitalized }, selection: $viewModel.selectedDamageType)
                        }
                        if !viewModel.castTimeOptions.isEmpty {
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                            TomeChipGroup(title: "Cast Time", options: viewModel.castTimeOptions, label: { $0 }, selection: $viewModel.selectedCastTime)
                        }
                        if !viewModel.rangeTypeOptions.isEmpty {
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                            TomeChipGroup(title: "Range", options: viewModel.rangeTypeOptions, label: { $0 }, selection: $viewModel.selectedRangeType)
                        }
                    }
                }

                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                        .padding(.horizontal, 14)
                        .padding(.top, 8)
                }

                if !viewModel.allSpells.isEmpty {
                    HStack(spacing: 8) {
                        Text("\(viewModel.spells.count) spell\(viewModel.spells.count == 1 ? "" : "s")")
                            .font(.custom("IMFellEnglish-Regular", size: 10))
                            .italic()
                            .foregroundStyle(Color.tomeSepia)
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.tomeGold))
                                .scaleEffect(0.6)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
                    .padding(.bottom, 2)
                }

                if viewModel.isLoading && viewModel.allSpells.isEmpty {
                    TomeLoadingView()
                    Spacer()
                } else if viewModel.spells.isEmpty {
                    TomeEmptyStateView(
                        message: viewModel.hasActiveFilters
                            ? "No spells match the active filters."
                            : "No incantations found in the arcane index.\nRefine your search above."
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.spells) { spell in
                            NavigationLink(destination: SpellDetailView(spell: spell)) {
                                TomeListRow(
                                    title: spell.name,
                                    subtitle: spell.school,
                                    badge: spell.level == 0 ? "Cantrip" : "Lvl \(spell.level)"
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(rowBackground)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 3, leading: 14, bottom: 3, trailing: 14))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.tomeParchment.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(Color.tomeSepia, lineWidth: 0.8)
            )
            .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack { SpellLookupView() }
}
