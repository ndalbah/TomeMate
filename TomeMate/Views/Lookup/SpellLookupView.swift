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
            VStack(spacing: 14) {
                TomeSearchBar(
                    placeholder: "Seek a spell...",
                    text: $viewModel.searchText
                )
                // Error
                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                }
                
                // Content
                if viewModel.isLoading && viewModel.spells.isEmpty {
                    TomeLoadingView()
                } else if viewModel.spells.isEmpty {
                    TomeEmptyStateView(message: "No incantations found in the arcane index.\nRefine your search above.")
                } else {
                    List {
                        ForEach(viewModel.spells) { spell in
                            NavigationLink(destination: SpellDetailView(spell: spell)) {
                                TomeListRow(
                                    title: spell.name,
                                    subtitle: spell.school,
                                    badge: "Lvl \(spell.level)"
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.tomeParchment.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .strokeBorder(Color.tomeSepia.opacity(0.18), lineWidth: 0.8)
                                    )
                                    .padding(.vertical, 2)
                            )
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                        if viewModel.hasMorePages {
                            TomePagnationSpinner()
                                .onAppear { viewModel.fetchSpells() }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Spells")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SpellLookupView()
    }
}
