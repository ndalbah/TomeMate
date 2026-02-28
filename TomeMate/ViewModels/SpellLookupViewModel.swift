//
//  SpellLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class SpellLookupViewModel: ObservableObject {
    @Published var spells: [SpellModel] = []
    @Published var searchText = "" {
        didSet {
            // Reset to page 1 and re-fetch when search changes
            currentPage = 1
            totalPages = 1
            spells = []
            fetchSpells()
        }
    }
    @Published var errorMessage: String?
    @Published var isLoading = false

    private(set) var currentPage = 1
    private(set) var totalPages = 1
    var hasMorePages: Bool { currentPage <= totalPages }

    init() { fetchSpells() }

    func fetchSpells() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchSpells(query: searchText, page: currentPage) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.totalPages = paginated.total_pages
                self.spells.append(contentsOf: paginated.data)
                self.currentPage += 1
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func resetAndFetch() {
        currentPage = 1
        totalPages = 1
        spells = []
        fetchSpells()
    }
}
