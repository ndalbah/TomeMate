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
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()

            VStack {
                ArcaneTextField(title: "Search Spell", text: $viewModel.searchText)

                List {
                    ForEach(viewModel.spells) { spell in
                        VStack(alignment: .leading) {
                            Text(spell.name)
                                .font(.headline)
                            Text(spell.description)
                                .font(.caption)
                                .lineLimit(3)
                        }
                    }

                    // Pagination trigger at bottom of list
                    if viewModel.hasMorePages {
                        HStack {
                            Spacer()
                            ProgressView()
                                .onAppear { viewModel.fetchSpells() }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Spells")
    }
}

#Preview {
    SpellLookupView()
}
