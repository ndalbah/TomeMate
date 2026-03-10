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
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()

            VStack {
                TextField("", text: $viewModel.searchText, prompt: Text("Search Item").foregroundColor(.black))
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.06),
                                Color.purple.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(ArcaneTheme.glow.opacity(0.6), lineWidth: 1)
                    )
                    .cornerRadius(14)
                    .shadow(color: ArcaneTheme.glow.opacity(0.4), radius: 10)
                List {
                    ForEach(viewModel.items) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.caption)
                                .lineLimit(3)
                        }
                    }

                    // Pagination trigger at bottom of list
                    if viewModel.hasMorePages {
                        HStack {
                            Spacer()
                            ProgressView()
                                .onAppear { viewModel.fetchItems() }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Items")
    }
}
