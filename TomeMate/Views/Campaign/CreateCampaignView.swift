//
//  CreateCampaignView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct CreateCampaignView: View {
    @State private var title: String = ""
    let character: Character?
    @Binding var path: NavigationPath                         
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var body: some View {
        VStack {
            Spacer()
            Text("Name the Tale of your Epic Adventure")
                .font(.title)
                .bold()
                .padding()
            TextField("", text: $title)
                .multilineTextAlignment(.center)
                .frame(width: 250)
                .submitLabel(.done)
            Rectangle()
                .frame(width: 250, height: 1)
                .foregroundStyle(Color.gray)
            Spacer()
            Button {
                let campaign = holder.createCampaign(title: title, character: character!, context)
                path.append(campaign)
            } label: {
                Label("Create Campaign", systemImage: "map")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
        }
    }
}
