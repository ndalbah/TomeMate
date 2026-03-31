//
//  BestiaryLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class BestiaryLookupViewModel: ObservableObject {
    @Published var allCreatures: [CreatureModel] = []
    @Published var creatures: [CreatureModel] = []

    @Published var searchText = ""
    { didSet { applyFilters() } }
    
    @Published var selectedType: String?
    { didSet { applyFilters() } }
    
    @Published var selectedSize: String?
    { didSet { applyFilters() } }
    
    @Published var selectedAlignment: String?
    { didSet { applyFilters() } }
    
    @Published var selectedCR: String?
    { didSet { applyFilters() } }

    @Published var errorMessage: String?
    @Published var isLoading = false

    private(set) var typeOptions: [String] = []
    private(set) var sizeOptions: [String] = []
    private(set) var alignmentOptions: [String] = []
    private(set) var crOptions: [String] = []

    var hasActiveFilters: Bool {
        selectedType != nil ||
        selectedSize != nil ||
        selectedAlignment != nil ||
        selectedCR != nil
    }

    private var currentPage = 1
    private var totalPages  = 1
    private var hasMorePages: Bool { currentPage <= totalPages }

    init() { fetchNextPage() }

    func fetchNextPage() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchCreatures(query: "", page: currentPage, pageSize: 50) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.allCreatures.append(contentsOf: paginated.data)
                self.totalPages = paginated.total_pages
                self.currentPage += 1
                self.buildOptionLists()
                self.applyFilters()
                
                if self.hasMorePages { self.fetchNextPage() }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.currentPage += 1
                    if self.hasMorePages { self.fetchNextPage() }
            }
        }
    }

    func clearFilters() {
        selectedType      = nil
        selectedSize      = nil
        selectedAlignment = nil
        selectedCR        = nil
    }

    private func buildOptionLists() {
        typeOptions      = Array(Set(allCreatures.map(\.type))).sorted()
        sizeOptions      = Array(Set(allCreatures.map(\.size))).sorted()
        alignmentOptions = Array(Set(allCreatures.map(\.alignment))).sorted()
        crOptions = Array(Set(allCreatures.map(\.challenge_rating))).sorted {
            (Double($0) ?? 0) < (Double($1) ?? 0)
        }
    }

    private func applyFilters() {
        var result = allCreatures
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter { $0.name.lowercased().contains(q) }
        }
        if let type      = selectedType      { result = result.filter { $0.type == type } }
        if let size      = selectedSize      { result = result.filter { $0.size == size } }
        if let alignment = selectedAlignment { result = result.filter { $0.alignment == alignment } }
        if let cr        = selectedCR        { result = result.filter { $0.challenge_rating == cr } }
        creatures = result
    }
}
