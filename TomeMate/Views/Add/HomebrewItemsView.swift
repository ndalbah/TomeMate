//
//  HomebrewItemsView.swift
//  TomeMate
//
//  Created by NRD on 30/03/2026.
//

import SwiftUI
import CoreData

struct HomebrewItemsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let character: Character?
    
    @StateObject private var viewModel = ItemLookupViewModel()
    
    @State private var name = ""
    @State private var itemDescription = ""
    @State private var isMagic = false
    @State private var reqAttune = false
    @State private var armorClass = ""
    @State private var damageType = ""
    @State private var damageSeverity = ""
    
    var canCreate: Bool {
        !name.isEmpty && viewModel.selectedType != nil && viewModel.selectedRarity != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Item Name", text: $name)
                    TextField("Description", text: $itemDescription)
                }
                
                Section("Properties") {
                    Picker("Type", selection: $viewModel.selectedType) {
                        Text("Select").tag(String?.none)
                        ForEach(viewModel.homebrewTypeOptions, id: \.self) { type in
                            Text(type).tag(String?.some(type))
                        }
                    }
                    
                    
                    
                    Picker("Rarity", selection: $viewModel.selectedRarity) {
                        Text("Select").tag(String?.none)
                        ForEach(viewModel.rarityOptions, id: \.self) { rarity in
                            Text(rarity.capitalized).tag(String?.some(rarity))
                        }
                    }
                    
                    Toggle("Magic Item", isOn: $isMagic)
                    Toggle("Requires Attunement", isOn: $reqAttune)
                }
                
                
                if(viewModel.selectedType == "Armor"){
                    Section("Armor Class"){
                        TextField("Armor Class", text: $armorClass)
                    }
                }
                
                if(viewModel.selectedType == "Weapon"){
                    Section("Damage Details"){
                        TextField("Damage Type", text: $damageType)
                        TextField("Damage Severity", text: $damageSeverity)
                    }
                }
                
                Section {
                    Button(action: saveHomebrewItem) {
                        HStack {
                            Spacer()
                            Text("Create Item").bold()
                            Spacer()
                        }
                    }
                    .disabled(!canCreate)
                }
            }
            .navigationTitle("New Item")
        }
    }
    
    private func saveHomebrewItem() {
        let newItem = Item(context: viewContext)
        
        newItem.id = UUID().uuidString
        newItem.name = name
        newItem.desc = itemDescription
        newItem.type = viewModel.selectedType
        newItem.rarity = viewModel.selectedRarity
        newItem.isMagic = isMagic
        newItem.isHomebrew = true
        newItem.reqAttune = reqAttune
        
        if let character = character {
            newItem.addToCharacter(character)
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
}

#Preview {
    HomebrewItemsView(character: nil)
}
