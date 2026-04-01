//
//  SpellsView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-21.
import SwiftUI

struct SpellsView: View {
    @State var spells: [Spell] = []
    let character: Character?
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @State private var showingAddSheet = false
    @State private var showingHomebrewSheet = false
    @State private var showingActionSheet = false
    
    var body: some View {
            ZStack {
                Color.tomeBg.ignoresSafeArea()
                TomeParticlesView()
                VStack(spacing: 14) {
                    spellList
                }
                .navigationTitle("Spells")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingActionSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.tomeGold)
                        }
                    }
                }
                // Compendium picker
                .sheet(isPresented: $showingAddSheet, onDismiss: refreshSpells) {
                    AddSpellView(character: character)
                        .environment(\.managedObjectContext, context)
                }
                // Homebrew creator
                .sheet(isPresented: $showingHomebrewSheet, onDismiss: refreshSpells) {
                    HomebrewSpellsView(character: character)
                        .environment(\.managedObjectContext, context)
                }
                .confirmationDialog("Add a Spell", isPresented: $showingActionSheet, titleVisibility: .visible) {
                    Button("From Compendium") { showingAddSheet = true }
                    Button("Create Homebrew")  { showingHomebrewSheet = true }
                    Button("Cancel", role: .cancel) { }
                }
                .onAppear(perform: refreshSpells)
            }
        }
    
    
    private func refreshSpells() {
        let set = character?.spells as? Set<Spell> ?? []
        spells = set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    private var spellList: some View {
        List {
            ForEach(spells) { spell in
                spellRow(for: spell)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private func spellRow(for spell: Spell) -> some View {
        NavigationLink(destination: CharacterSpellDetailView(spell: spell)) {
            TomeListRow(
                title: spell.name!,
                subtitle: spell.school!,
                badge: "Lvl \(spell.level)"
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
    SpellsView(character: nil)
}
