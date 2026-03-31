//
//  SpellModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct SpellModel: Identifiable, Codable {
    let id: String
    let name: String
    let level: Int16
    let school: String
    let cast_time: String
    let components: [String] // v, s, m -- if m => material. v = vocal, m = material, s = somatic
    let material: String?
    let durationType: String
    let is_concentration: Bool
    let spell_duration_unit: String?
    let durationAmount: Int16?
    let range_type: String
    let range_amount: Int16?
    let range_unit: String?
    let description: String
    let damage_type: String?
    let condition_type: [String]?
    let saving_throw_type: String?
}


//ranged? //toggle
// if yes
// textfield for range type and amount

// if not
// range type = touch
