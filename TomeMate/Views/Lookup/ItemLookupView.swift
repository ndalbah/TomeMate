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
            Color.tomeBg
                .ignoresSafeArea()
            TomeParticlesView()
            VStack(spacing: 14) {
                TomeSearchBar(
                    placeholder: "Search the vault...",
                    text: $viewModel.searchText
                )
                
                // Error
                if let error = viewModel.errorMessage {
                    TomeLookupErrorView(message: error)
                }
                
                if viewModel.isLoading && viewModel.items.isEmpty {
                    TomeLoadingView()
                } else if viewModel.items.isEmpty {
                    TomeEmptyStateView(message: "The vaults have found no search treasure. \n Please try again.")
                } else {
                    List {
                        ForEach(viewModel.items) {
                            item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                TomeListRow(title: item.name, subtitle: item.type, badge: item.rarity)
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
                                .onAppear { viewModel.fetchItems() }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Items")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ItemLookupView()
    }
}
