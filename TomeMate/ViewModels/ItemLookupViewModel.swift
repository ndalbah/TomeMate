//
//  ItemLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class ItemLookupViewModel: ObservableObject {
    @Published var allItems: [ItemModel] = []
    @Published var items: [ItemModel] = []

    @Published var searchText = ""         { didSet { applyFilters() } }
    @Published var selectedType: String?   { didSet { applyFilters() } }
    @Published var selectedRarity: String? { didSet { applyFilters() } }
    @Published var selectedMagic: Bool?    { didSet { applyFilters() } }

    @Published var errorMessage: String?
    @Published var isLoading = false

    private(set) var typeOptions: [String]   = []
    
    let rarityOptions: [String] = ["Common", "Uncommon", "Rare", "Very Rare", "Legendary", "Artifact"]
    let homebrewTypeOptions: [String] = ["Armor", "Weapon"]

    private var currentPage = 1
    private var totalPages  = 1
    private var hasMorePages: Bool { currentPage <= totalPages }

    var hasActiveFilters: Bool {
        selectedType != nil || selectedRarity != nil || selectedMagic != nil
    }

    init() { fetchNextPage() }

    func fetchNextPage() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchItems(query: "", page: currentPage, pageSize: 50) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.allItems.append(contentsOf: paginated.data)
                self.totalPages = paginated.total_pages
                self.currentPage += 1
                self.buildOptionLists()
                self.applyFilters()

                if self.hasMorePages { self.fetchNextPage() }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func clearFilters() {
        selectedType   = nil
        selectedRarity = nil
        selectedMagic  = nil
    }
    
    private func buildOptionLists() {
        typeOptions = Array(Set(allItems.map(\.type))).filter { !$0.isEmpty }.sorted()
    }

    private func applyFilters() {
        var result = allItems
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter { $0.name.lowercased().contains(q) }
        }
        if let type   = selectedType   { result = result.filter { $0.type == type } }
        if let rarity = selectedRarity { result = result.filter { $0.rarity == rarity } }
        if let magic  = selectedMagic  { result = result.filter { $0.isMagic == magic } }
        items = result
    }
}
