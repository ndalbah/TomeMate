//
//  ItemModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct ItemModel: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let rarity: String
    let description: String
    let isMagic: Bool
    
    // armor types + weapon types additions
    let reqAttune: String?
    let weight: Double?
    let value: Int?
    let bonusWeapon: String?
    let bonusAc: String?
    let bonusSpellAttack: String?
    let bonusSpellSaveDc: String?
    let wondrous: Bool?
}

// types options
// armor => armor class
// weapon => damage type, damage
