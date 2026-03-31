//
//  ItemLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct ItemLookupView: View {
    @StateObject private var viewModel = ItemLookupViewModel()

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                TomeSearchBar(placeholder: "Search the vault...", text: $viewModel.searchText)
                    .padding(.horizontal, 14)
                    .padding(.top, 14)
                    .padding(.bottom, 8)

                if !viewModel.allItems.isEmpty {
                    TomeFilterBar {
                        if viewModel.hasActiveFilters {
                            TomeClearFiltersButton { viewModel.clearFilters() }
                        }
                        if !viewModel.typeOptions.isEmpty {
                            TomeChipGroup(title: "Type", options: viewModel.typeOptions, label: { $0 }, selection: $viewModel.selectedType)
                            Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        }
                        TomeChipGroup(title: "Rarity", options: viewModel.rarityOptions, label: { $0 }, selection: $viewModel.selectedRarity)
                        Divider().frame(height: 18).background(Color.tomeSepia.opacity(0.3))
                        HStack(spacing: 6) {
                            Text("MAGIC")
                                .font(.custom("Cinzel-Regular", size: 8))
                                .tracking(1.5)
                                .foregroundStyle(Color.tomeSepia)
                            TomeBoolChip(trueLabel: "Magical", falseLabel: "Mundane", selection: $viewModel.selectedMagic)
                        }
                    }
                }

                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                        .padding(.horizontal, 14)
                        .padding(.top, 8)
                }

                if !viewModel.allItems.isEmpty {
                    HStack(spacing: 8) {
                        Text("\(viewModel.items.count) item\(viewModel.items.count == 1 ? "" : "s")")
                            .font(.custom("IMFellEnglish-Regular", size: 10))
                            .italic()
                            .foregroundStyle(Color.tomeSepia.opacity(0.7))
                        
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

                if viewModel.isLoading && viewModel.allItems.isEmpty {
                    TomeLoadingView()
                    Spacer()
                } else if viewModel.items.isEmpty {
                    TomeEmptyStateView(
                        message: viewModel.hasActiveFilters
                            ? "No items match the active filters."
                            : "The vaults hold no such treasure.\nPlease try again."
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                TomeListRow(title: item.name, subtitle: item.type, badge: item.rarity)
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
        .navigationTitle("Items")
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
    NavigationStack { ItemLookupView() }
}
