//
//  CreatureModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct CreatureModel: Identifiable, Codable {
    let id: String
    let name: String
    let size: String
    let type: String
    let subtype: String?
    let alignment: String
    let armor_class: Int
    let hit_points: Int
    let hit_dice: String?
    let challenge_rating: String
    let speed: String?
    let strength: Int?
    let dexterity: Int?
    let constitution: Int?
    let intelligence: Int?
    let wisdom: Int?
    let charisma: Int?
    let senses: String?
    let languages: String?
    let damage_resistances: String?
    let damage_immunities: String?
    let damage_vulnerabilities: String?
    let condition_immunities: String?
}
