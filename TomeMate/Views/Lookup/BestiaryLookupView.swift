//
//  BestiaryLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct BestiaryLookupView: View {
    @StateObject private var viewModel = BestiaryLookupViewModel()

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                TomeSearchBar(placeholder: "Name a creature...", text: $viewModel.searchText)
                    .padding(.horizontal, 14)
                    .padding(.top, 14)
                    .padding(.bottom, 8)

                if !viewModel.allCreatures.isEmpty {
                    TomeFilterBar {
                        if viewModel.hasActiveFilters {
                            TomeClearFiltersButton { viewModel.clearFilters() }
                        }
                        if !viewModel.typeOptions.isEmpty {
                            TomeChipGroup(title: "Type", options: viewModel.typeOptions, label: { $0.capitalized }, selection: $viewModel.selectedType)
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        if !viewModel.sizeOptions.isEmpty {
                            TomeChipGroup(title: "Size", options: viewModel.sizeOptions, label: { $0 }, selection: $viewModel.selectedSize)
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        if !viewModel.crOptions.isEmpty {
                            TomeChipGroup(title: "CR", options: viewModel.crOptions, label: { $0 }, selection: $viewModel.selectedCR)
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        if !viewModel.alignmentOptions.isEmpty {
                            TomeChipGroup(title: "Alignment", options: viewModel.alignmentOptions, label: { $0.capitalized }, selection: $viewModel.selectedAlignment)
                        }
                    }
                }

                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                        .padding(.horizontal, 14)
                        .padding(.top, 8)
                }

                if !viewModel.allCreatures.isEmpty {
                    HStack(spacing: 8) {
                        Text("\(viewModel.creatures.count) creature\(viewModel.creatures.count == 1 ? "" : "s")")
                            .font(.custom("IMFellEnglish-Regular", size: 10))
                            .italic()
                            .foregroundStyle(Color.tomeSepia.opacity(0.7))
                        // Small inline spinner while remaining pages are still loading
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

                if viewModel.isLoading && viewModel.allCreatures.isEmpty {
                    TomeLoadingView()
                    Spacer()
                } else if viewModel.creatures.isEmpty {
                    TomeEmptyStateView(
                        message: viewModel.hasActiveFilters
                            ? "No creatures match the active filters."
                            : "No creatures stir in the bestiary."
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.creatures) { creature in
                            NavigationLink(destination: BestiaryDetailView(creature: creature)) {
                                TomeListRow(
                                    title: creature.name,
                                    subtitle: "\(creature.size) \(creature.type) · \(creature.alignment)",
                                    badge: "CR \(creature.challenge_rating)"
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
        .navigationTitle("Bestiary")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.tomeParchment.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(Color.tomeSepia.opacity(0.18), lineWidth: 0.8)
            )
            .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack { BestiaryLookupView() }
}
