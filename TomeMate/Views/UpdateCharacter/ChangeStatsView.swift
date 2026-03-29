//
//  ChangeStatsView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-28.
//

import SwiftUI

struct ChangeStatsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character?
    @State var stats: Stats?
    @State var strvalue: Double = 10
    @State var dexvalue: Double = 10
    @State var convalue: Double = 10
    @State var intvalue: Double = 10
    @State var wisvalue: Double = 10
    @State var chavalue: Double = 10
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Spacer()
                Text("Stats")
                    .font(.title)
                Spacer()
            }
            .padding(.bottom, 10)
            Spacer()

            StatSliderRow(label: "Strength",     value: $strvalue)
            StatSliderRow(label: "Dexterity",    value: $dexvalue)
            StatSliderRow(label: "Constitution", value: $convalue)
            StatSliderRow(label: "Intelligence", value: $intvalue)
            StatSliderRow(label: "Wisdom",       value: $wisvalue)
            StatSliderRow(label: "Charisma",     value: $chavalue)
            Spacer()
            VStack{
                Button {
        
                    holder.updateStat(str: strvalue, dex: dexvalue, con: convalue, int: intvalue, wis: wisvalue, cha: chavalue, stat: stats!, context)
                    dismiss()
                    
                } label: {
                    Text("Save Stats")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .onAppear {
            stats = character?.stats
            strvalue = Double(stats?.strength ?? 0)
            dexvalue = Double(stats?.dexterity ?? 0)
            convalue = Double(stats?.constitution ?? 0)
            intvalue = Double(stats?.intelligence ?? 0)
            wisvalue = Double(stats?.wisdom ?? 0)
            chavalue = Double(stats?.charisma ?? 0)
        }
    }
}


struct StatSliderRow: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(width: 120, alignment: .leading)

            Spacer()

            Button(action: {
                if value > 0 { value -= 1 }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }

            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(Circle().fill(Color.white))
                        .frame(width: 44, height: 44)
                    Text("\(Int(value))")
                        .font(.title3)
                }
                Text(returnModifier(value: value))
                    .font(.caption)
            }
            .padding(.horizontal, 8)

            Button(action: {
                if value < 20 { value += 1 }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }

    private func returnModifier(value: Double) -> String {
        let modifier = Int(floor((value - 10) / 2))
        return modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
}



#Preview {
    // ChangeStatsView()
}

