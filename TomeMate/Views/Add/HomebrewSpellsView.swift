//
//  HomebrewSpellsView.swift
//  TomeMate
//
//  Created by NRD on 30/03/2026.
//

import SwiftUI
import CoreData

struct HomebrewSpellsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let character: Character?
    
    @StateObject private var viewModel = SpellLookupViewModel()
    

    @State private var name = ""
    @State private var description = ""
    @State private var materialText = ""
    @State private var isRanged = false
    @State private var rangeAmount = ""
    @State private var selectedComponents: Set<String> = []

    var canCreate: Bool {
        !name.isEmpty && viewModel.selectedLevel != nil && viewModel.selectedSchool != nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Spell Name", text: $name)
                    TextField("Description", text: $description)
                }

                Section("Spell Properties") {
                    Picker("Level", selection: $viewModel.selectedLevel) {
                        Text("Select").tag(Int16?.none)
                        ForEach(viewModel.levelOptions, id: \.self) { level in
                            Text(level == 0 ? "Cantrip" : "Level \(level)").tag(Int16?.some(level))
                        }
                    }
                    
                    Picker("School", selection: $viewModel.selectedSchool) {
                        Text("Select").tag(String?.none)
                        ForEach(viewModel.schoolOptions, id: \.self) { school in
                            Text(school.capitalized).tag(String?.some(school))
                        }
                    }
                    
                    Toggle("Requires Concentration", isOn: Binding(
                        get: { viewModel.selectedConcentration ?? false },
                        set: { viewModel.selectedConcentration = $0 }
                    ))
                }

                Section("Casting & Range") {
                    Picker("Cast Time", selection: $viewModel.selectedCastTime) {
                        Text("Select").tag(String?.none)
                        ForEach(viewModel.castTimeOptions, id: \.self) { time in
                            Text(time).tag(String?.some(time))
                        }
                    }
                    
                    Toggle("Ranged", isOn: $isRanged)
                        .onChange(of: isRanged) { _, newValue in
                            if !newValue { rangeAmount = "Touch" }
                        }
                }
                
                if isRanged {
                    Section("Range Details") {
                        Picker("Range Type", selection: $viewModel.selectedRangeType) {
                            Text("Select").tag(String?.none)
                            ForEach(viewModel.rangeTypeOptions, id: \.self) { range in
                                Text(range).tag(String?.some(range))
                            }
                        }
                        TextField("Range Amount", text: $rangeAmount)
                    }
                }

                
                Section("Components") {
                    ForEach(["Verbal", "Somatic", "Material"], id: \.self) { component in
                        Button {
                            if selectedComponents.contains(component) {
                                selectedComponents.remove(component)
                            } else {
                                selectedComponents.insert(component)
                            }
                        } label: {
                            HStack {
                                Text(component)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedComponents.contains(component) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.tomeGold)
                                }
                            }
                        }
                    }

                    if selectedComponents.contains("Material") {
                        TextField("Material component", text: $materialText)
                    }
                }

                Section {
                    Button(action: saveHomebrewSpell) {
                        HStack {
                            Spacer()
                            Text("Create Spell")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(!canCreate)
                }
            }
            .navigationTitle("New Homebrew")
        }
    }

    private func saveHomebrewSpell() {
        let newSpell = Spell(context: viewContext)
        
        newSpell.spellId = UUID()
        newSpell.name = name
        newSpell.level = viewModel.selectedLevel ?? 0
        newSpell.school = viewModel.selectedSchool
        newSpell.castTime = viewModel.selectedCastTime
        newSpell.is_concentration = viewModel.selectedConcentration ?? false
        newSpell.desc = description
        newSpell.isHomebrew = true
        
        let componentList = selectedComponents.map { component -> String in
            switch component {
            case "Verbal":   return "v"
            case "Somatic":  return "s"
            case "Material": return "m"
            default:         return component.lowercased()
            }
        }
        newSpell.components = componentList
        newSpell.materials = selectedComponents.contains("Material") ? materialText : nil
        
        // Range
        if isRanged {
            newSpell.range_type = viewModel.selectedRangeType
            if let amount = Int16(rangeAmount) {
                newSpell.range_amount = amount
            }
        } else {
            newSpell.range_type = "touch"
            newSpell.range_amount = 0
        }
        
        if let character = character {
            newSpell.addToCharacter(character)
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    HomebrewSpellsView(character: nil)
}
