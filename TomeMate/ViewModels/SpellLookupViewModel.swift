//
//  SpellLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class SpellLookupViewModel: ObservableObject {
    @Published var allSpells: [SpellModel] = []
    @Published var spells: [SpellModel] = []
    @Published var searchText = "" { didSet { applyFilters() } }

    // Active filter selections
    @Published var selectedLevel: Int16?         { didSet { applyFilters() } }
    @Published var selectedSchool: String?       { didSet { applyFilters() } }
    @Published var selectedConcentration: Bool?  { didSet { applyFilters() } }
    @Published var selectedDamageType: String?   { didSet { applyFilters() } }
    @Published var selectedMaterial: String?     { didSet { applyFilters() } }
    @Published var selectedCastTime: String?     { didSet { applyFilters() } }
    @Published var selectedDurationType: String? { didSet { applyFilters() } }
    @Published var selectedRangeType: String?    { didSet { applyFilters() } }

    @Published var errorMessage: String?
    @Published var isLoading = false

    // Option lists
    private(set) var schoolOptions: [String]       = []
    private(set) var damageTypeOptions: [String]   = []
    private(set) var levelOptions: [Int16]         = []
    private(set) var materialOptions: [String]     = []
    private(set) var castTimeOptions: [String]     = []
    private(set) var durationTypeOptions: [String] = []
    private(set) var rangeTypeOptions: [String]    = []

    private(set) var currentPage = 1
    private(set) var totalPages  = 1
    var hasMorePages: Bool { currentPage <= totalPages }

    init() { fetchSpells() }

    func fetchSpells() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchSpells(query: "", page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.allSpells.append(contentsOf: paginated.data)
                self.totalPages = paginated.total_pages
                self.currentPage += 1
                self.buildOptionLists()
                self.applyFilters()
                if self.hasMorePages { self.fetchSpells() }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func buildOptionLists() {
        levelOptions = Array(Set(allSpells.map(\.level))).sorted()
        schoolOptions = Array(Set(allSpells.map(\.school))).sorted()
        damageTypeOptions = Array(Set(allSpells.compactMap(\.damage_type))).sorted()
        materialOptions = Array(Set(allSpells.compactMap(\.material))).sorted()
        castTimeOptions = Array(Set(allSpells.map(\.cast_time))).sorted()
        durationTypeOptions = Array(Set(allSpells.map(\.durationType))).sorted()
        rangeTypeOptions = Array(Set(allSpells.map(\.range_type))).sorted()
    }

    func applyFilters() {
        var result = allSpells
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        if let level = selectedLevel { result = result.filter { $0.level == level } }
        if let school = selectedSchool { result = result.filter { $0.school == school } }
        if let conc = selectedConcentration { result = result.filter { $0.is_concentration == conc } }
        if let dmg = selectedDamageType { result = result.filter { $0.damage_type == dmg } }
        if let cast = selectedCastTime { result = result.filter { $0.cast_time == cast } }
        if let dur = selectedDurationType { result = result.filter { $0.durationType == dur } }
        if let rng = selectedRangeType { result = result.filter { $0.range_type == rng } }
        
        self.spells = result
    }
    
    var hasActiveFilters: Bool {
            selectedLevel != nil ||
            selectedSchool != nil ||
            selectedConcentration != nil ||
            selectedDamageType != nil ||
            selectedMaterial != nil ||
            selectedCastTime != nil ||
            selectedDurationType != nil ||
            selectedRangeType != nil
        }

    func clearFilters() {
        selectedLevel = nil
        selectedSchool = nil
        selectedConcentration = nil
        selectedDamageType = nil
        selectedMaterial = nil
        selectedCastTime = nil
        selectedDurationType = nil
        selectedRangeType = nil
    }
}
