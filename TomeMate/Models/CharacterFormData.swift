//
//  CharacterFormData.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import Foundation

struct CharacterFormData {
    let id:UUID = UUID()
    var name: String = ""
    var age: Int = 0
    var alignment: String = ""
    var background: String = ""
    var charImg: String = ""
    var race: String = ""
    var languages: String = ""
    var subrace: String = ""
    var strength: Int = 0
    var dexterity: Int = 0
    var intelligence: Int = 0
    var constitution: Int = 0
    var wisdom: Int = 0
    var charisma: Int = 0
    var skills: [SkillsModel] = []
    var charClass: ClassesModel = ClassesModel(id: "", name: "", source: "", page: 0, hitDice: 0, primaryAbility: "")
    var subclass: SubclassModel = SubclassModel(id: "", name: "", shortName: "", className: "", source: "", page: 0)
}

struct SkillsModel: Identifiable, Codable{
    var id:String
    var name: String
    var ability: String
    var entry: String
    var isProficient: Bool
}

struct ClassesModel: Identifiable, Codable{
    var id:String
    var name: String
    var source: String
    var page: Int
    var hitDice: Int
    var primaryAbility: String
}

struct SubclassModel: Identifiable, Codable{
    var id:String
    var name: String
    var shortName: String
    var className: String
    var source: String
    var page: Int
}


