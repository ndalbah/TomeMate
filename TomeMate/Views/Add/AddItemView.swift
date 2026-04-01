//
//  AddItemView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-31.
//

import SwiftUI
import CoreData
 
struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
 
    let character: Character?
 
    @StateObject private var viewModel = ItemLookupViewModel()
 
    @State private var showingFilters = false
    @State private var addedItemIDs: Set<String> = []
    @State private var confirmItem: ItemModel? = nil
 
    private var existingItemIDs: Set<String> {
        let set = character?.items as? Set<Item> ?? []
        return Set(set.compactMap(\.id))
    }
 
    var body: some View {
        NavigationView {
            ZStack {
                Color.tomeBg.ignoresSafeArea()
 
                VStack(spacing: 0) {
                    // Search bar
                    searchBar
                        .padding(.horizontal)
                        .padding(.top, 8)
 
                    // Active filter chips
                    if viewModel.hasActiveFilters {
                        activeFilterChips
                            .padding(.horizontal)
                            .padding(.top, 6)
                    }
 
                    Divider().padding(.top, 8)
 
                    // Item list
                    if viewModel.isLoading && viewModel.items.isEmpty {
                        Spacer()
                        ProgressView("Loading items…")
                            .foregroundColor(.tomeSepia)
                        Spacer()
                    } else if viewModel.items.isEmpty {
                        Spacer()
                        Text("No items found")
                            .foregroundColor(.tomeSepia.opacity(0.6))
                        Spacer()
                    } else {
                        itemList
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(systemName: viewModel.hasActiveFilters
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                            .foregroundColor(.tomeGold)
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                ItemFilterSheet(viewModel: viewModel)
            }
            .confirmationDialog(
                confirmItem.map { "Add \($0.name) to \(character?.name ?? "character")?" } ?? "",
                isPresented: Binding(
                    get: { confirmItem != nil },
                    set: { if !$0 { confirmItem = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Add Item") {
                    if let item = confirmItem { addItem(item) }
                }
                Button("Cancel", role: .cancel) { confirmItem = nil }
            }
        }
    }
 
    // MARK: – Subviews
 
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.tomeSepia.opacity(0.6))
            TextField("Search items…", text: $viewModel.searchText)
                .foregroundColor(.tomeParchment)
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.tomeSepia.opacity(0.5))
                }
            }
        }
        .padding(10)
        .background(Color.tomeParchment.opacity(0.12))
        .cornerRadius(10)
    }
 
    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let type = viewModel.selectedType {
                    ItemFilterChip(label: type.capitalized) { viewModel.selectedType = nil }
                }
                if let rarity = viewModel.selectedRarity {
                    ItemFilterChip(label: rarity.capitalized) { viewModel.selectedRarity = nil }
                }
                if let magic = viewModel.selectedMagic {
                    ItemFilterChip(label: magic ? "Magic" : "Non-Magic") {
                        viewModel.selectedMagic = nil
                    }
                }
                Button("Clear all") { viewModel.clearFilters() }
                    .font(.caption).foregroundColor(.tomeGold)
            }
        }
    }
 
    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                itemRow(for: item)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
 
    @ViewBuilder
    private func itemRow(for item: ItemModel) -> some View {
        let alreadyAdded = existingItemIDs.contains(item.id) || addedItemIDs.contains(item.id)
 
        Button {
            guard !alreadyAdded else { return }
            confirmItem = item
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(alreadyAdded ? .tomeSepia.opacity(0.45) : .tomeParchment)
                    HStack(spacing: 6) {
                        if !item.type.isEmpty {
                            Text(item.type.capitalized)
                                .font(.caption)
                                .foregroundColor(.tomeGold.opacity(0.8))
                            Text("·")
                                .font(.caption)
                                .foregroundColor(.tomeSepia.opacity(0.5))
                        }
                        Text(item.rarity.isEmpty ? "Common" : item.rarity.capitalized)
                            .font(.caption)
                            .foregroundColor(.tomeSepia.opacity(0.7))
                        if item.isMagic {
                            Text("· ✦ Magic")
                                .font(.caption)
                                .foregroundColor(.purple.opacity(0.7))
                        }
                    }
                }
                Spacer()
                if alreadyAdded {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.tomeGold.opacity(0.6))
                } else {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.tomeGold)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .listRowBackground(rowBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 3, leading: 12, bottom: 3, trailing: 12))
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
 
    // MARK: – CoreData save
 
    private func addItem(_ item: ItemModel) {
        let newItem = Item(context: viewContext)
        newItem.id = item.id
        newItem.name = item.name
        newItem.type = item.type
        newItem.rarity = item.rarity
        newItem.desc = item.description
        newItem.isMagic = item.isMagic
        newItem.isHomebrew = false
 
        if let character = character {
            newItem.addToCharacter(character)
        }
 
        do {
            try viewContext.save()
            addedItemIDs.insert(item.id)
        } catch {
            print("Failed to save item: \(error)")
        }
        confirmItem = nil
    }
}
 
// MARK: – Filter sheet
 
private struct ItemFilterSheet: View {
    @ObservedObject var viewModel: ItemLookupViewModel
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("Type", selection: $viewModel.selectedType) {
                        Text("Any").tag(String?.none)
                        ForEach(viewModel.typeOptions, id: \.self) { t in
                            Text(t.capitalized).tag(String?.some(t))
                        }
                    }
                }
                Section("Rarity") {
                    Picker("Rarity", selection: $viewModel.selectedRarity) {
                        Text("Any").tag(String?.none)
                        ForEach(viewModel.rarityOptions, id: \.self) { r in
                            Text(r.capitalized).tag(String?.some(r))
                        }
                    }
                }
                Section("Magic") {
                    Picker("Magic", selection: $viewModel.selectedMagic) {
                        Text("Any").tag(Bool?.none)
                        Text("Magic Items Only").tag(Bool?.some(true))
                        Text("Non-Magic Only").tag(Bool?.some(false))
                    }
                }
                Section {
                    Button("Clear All Filters", role: .destructive) {
                        viewModel.clearFilters()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Filter Items")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
 
// MARK: – Reusable chip
 
private struct ItemFilterChip: View {
    let label: String
    let onRemove: () -> Void
 
    var body: some View {
        HStack(spacing: 4) {
            Text(label).font(.caption).foregroundColor(.tomeParchment)
            Button(action: onRemove) {
                Image(systemName: "xmark").font(.caption2).foregroundColor(.tomeSepia)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.tomeGold.opacity(0.25))
        .cornerRadius(20)
    }
}
 
#Preview {
    AddItemView(character: nil)
}
