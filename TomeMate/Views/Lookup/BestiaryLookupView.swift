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

            VStack(spacing: 14) {
                TomeSearchBar(placeholder: "Name a creature...", text: $viewModel.searchText)

                // Error
                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                }

                // Contents
                if viewModel.isLoading && viewModel.creatures.isEmpty {
                    TomeLoadingView()
                } else if viewModel.creatures.isEmpty {
                    TomeEmptyStateView(message: "No creatures stir in the bestiary. Refine your search above.")
                } else {
                    List {
                        ForEach(viewModel.creatures) { creature in
                            NavigationLink(destination: BestiaryDetailView(creature: creature)) {
                                TomeListRow(title: creature.name, subtitle: creature.alignment, badge: "\(creature.type)")
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
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Bestiary")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        BestiaryLookupView()
    }
}
