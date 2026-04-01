//
//  AddSpellView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-31.
//

import SwiftUI
import CoreData
 
struct AddSpellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
 
    let character: Character?
 
    @StateObject private var viewModel = SpellLookupViewModel()
 
    @State private var showingFilters = false
    @State private var addedSpellIDs: Set<String> = []
    @State private var confirmSpell: SpellModel? = nil
 
    // Pre-load existing spell IDs so we can mark already-added ones
    private var existingSpellIDs: Set<String> {
        let set = character?.spells as? Set<Spell> ?? []
        return Set(set.compactMap(\.name))
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
 
                    // Spell list
                    if viewModel.isLoading && viewModel.spells.isEmpty {
                        Spacer()
                        ProgressView("Loading spells…")
                            .foregroundColor(.tomeSepia)
                        Spacer()
                    } else if viewModel.spells.isEmpty {
                        Spacer()
                        Text("No spells found")
                            .foregroundColor(.tomeSepia.opacity(0.6))
                        Spacer()
                    } else {
                        spellList
                    }
                }
            }
            .navigationTitle("Add Spell")
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
                SpellFilterSheet(viewModel: viewModel)
            }
            .confirmationDialog(
                confirmSpell.map { "Add \($0.name) to \(character?.name ?? "character")?" } ?? "",
                isPresented: Binding(
                    get: { confirmSpell != nil },
                    set: { if !$0 { confirmSpell = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Add Spell") {
                    if let spell = confirmSpell { addSpell(spell) }
                }
                Button("Cancel", role: .cancel) { confirmSpell = nil }
            }
        }
    }
 
    // MARK: – Subviews
 
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.tomeSepia.opacity(0.6))
            TextField("Search spells…", text: $viewModel.searchText)
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
                if let lvl = viewModel.selectedLevel {
                    FilterChip(label: "Level \(lvl)") { viewModel.selectedLevel = nil }
                }
                if let school = viewModel.selectedSchool {
                    FilterChip(label: school.capitalized) { viewModel.selectedSchool = nil }
                }
                if let conc = viewModel.selectedConcentration {
                    FilterChip(label: conc ? "Concentration" : "No Concentration") {
                        viewModel.selectedConcentration = nil
                    }
                }
                if let dmg = viewModel.selectedDamageType {
                    FilterChip(label: dmg.capitalized) { viewModel.selectedDamageType = nil }
                }
                if let cast = viewModel.selectedCastTime {
                    FilterChip(label: cast.capitalized) { viewModel.selectedCastTime = nil }
                }
                Button("Clear all") { viewModel.clearFilters() }
                    .font(.caption).foregroundColor(.tomeGold)
            }
        }
    }
 
    private var spellList: some View {
        List {
            ForEach(viewModel.spells) { spell in
                spellRow(for: spell)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
 
    @ViewBuilder
    private func spellRow(for spell: SpellModel) -> some View {
        let alreadyAdded = existingSpellIDs.contains(spell.name) || addedSpellIDs.contains(spell.name)
 
        Button {
            guard !alreadyAdded else { return }
            confirmSpell = spell
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(spell.name)
                        .font(.headline)
                        .foregroundColor(alreadyAdded ? .tomeSepia.opacity(0.45) : .tomeParchment)
                    HStack(spacing: 6) {
                        Text(spell.school.capitalized)
                            .font(.caption)
                            .foregroundColor(.tomeGold.opacity(0.8))
                        Text("·")
                            .font(.caption)
                            .foregroundColor(.tomeSepia.opacity(0.5))
                        Text(spell.level == 0 ? "Cantrip" : "Level \(spell.level)")
                            .font(.caption)
                            .foregroundColor(.tomeSepia.opacity(0.7))
                        if spell.is_concentration {
                            Text("· Conc.")
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
 
    private func addSpell(_ spell: SpellModel) {
        let newSpell = Spell(context: viewContext)
        newSpell.spellId = UUID()
        newSpell.name = spell.name
        newSpell.level = spell.level
        newSpell.school = spell.school
        newSpell.castTime = spell.cast_time
        newSpell.range_type = spell.range_type
        newSpell.is_concentration = spell.is_concentration
        newSpell.desc = spell.description
        newSpell.materials = spell.material
        newSpell.isHomebrew = false
 
        if let character = character {
            newSpell.addToCharacter(character)
        }
 
        do {
            try viewContext.save()
            addedSpellIDs.insert(spell.id)
        } catch {
            print("Failed to save spell: \(error)")
        }
        confirmSpell = nil
    }
}
 
// MARK: – Filter sheet
 
private struct SpellFilterSheet: View {
    @ObservedObject var viewModel: SpellLookupViewModel
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationView {
            Form {
                Section("Level") {
                    Picker("Level", selection: $viewModel.selectedLevel) {
                        Text("Any").tag(Int16?.none)
                        ForEach(viewModel.levelOptions, id: \.self) { lvl in
                            Text(lvl == 0 ? "Cantrip" : "Level \(lvl)").tag(Int16?.some(lvl))
                        }
                    }
                }
                Section("School") {
                    Picker("School", selection: $viewModel.selectedSchool) {
                        Text("Any").tag(String?.none)
                        ForEach(viewModel.schoolOptions, id: \.self) { s in
                            Text(s.capitalized).tag(String?.some(s))
                        }
                    }
                }
                Section("Cast Time") {
                    Picker("Cast Time", selection: $viewModel.selectedCastTime) {
                        Text("Any").tag(String?.none)
                        ForEach(viewModel.castTimeOptions, id: \.self) { c in
                            Text(c.capitalized).tag(String?.some(c))
                        }
                    }
                }
                Section("Concentration") {
                    Picker("Concentration", selection: $viewModel.selectedConcentration) {
                        Text("Any").tag(Bool?.none)
                        Text("Required").tag(Bool?.some(true))
                        Text("Not Required").tag(Bool?.some(false))
                    }
                }
                Section {
                    Button("Clear All Filters", role: .destructive) {
                        viewModel.clearFilters()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Filter Spells")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
 
// MARK: – Reusable chip
 
private struct FilterChip: View {
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
    AddSpellView(character: nil)
}
