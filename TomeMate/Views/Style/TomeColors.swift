//
//  TomeColors.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

extension Color {
    static let tomeBg = Color("#100A04")
    static let tomeLeather = Color("#1E1008")
    static let tomeParchment = Color("#F2E4C4")
    static let tomeParchmentDark = Color("#D4C49A")
    static let tomeGold = Color("#C8962E")
    static let tomeGoldLight = Color("#CE8B4B")
    static let tomeGoldDim = Color("#7A5A1A")
    static let tomeCrimson = Color("#8B1A1A")
    static let tomeCrimsonLight = Color("#B02020")
    static let tomeInk = Color("#1C1208")
    static let tomeMuted = Color("#9C8B72")
    static let tomeSpine = Color("#2C1505")
    static let tomeSepia = Color("#7A5C2E")
    static let tomeParchmentText = Color("#5C4020")
    static let tomeParchmentLight = Color("#EDD99A")
    static let tomeParchmentMid = Color("#E4CC88")
    static let tomeParchmentDeep = Color("#D9BF7A")
    
    init(_ hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}
