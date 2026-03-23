//
//  ItemsView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-21.
//

import SwiftUI

struct ItemsView: View {
    @State var items: [Item] = []
    let character: Character?
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            VStack(spacing: 14) {
                itemList
            }
            .navigationTitle("Items")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                let set = character?.items as? Set<Item> ?? []
                items = set.sorted { $0.name ?? "" < $1.name ?? "" }
            }
        }
    }

    private var itemList: some View {
        List {
            ForEach(items) { item in
                itemRow(for: item)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func itemRow(for item: Item) -> some View {
        NavigationLink(destination: CharacterItemDetailView(item: item)) {
            TomeListRow(
                title: item.name ?? "",
                subtitle: item.type ?? "",
                badge: item.rarity ?? ""
            )
        }
        .buttonStyle(.plain)
        .listRowBackground(rowBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
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
    //ItemLookupView(character: nil)
}
