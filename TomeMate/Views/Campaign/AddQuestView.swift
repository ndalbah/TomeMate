//
//  AddQuestView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct AddQuestView: View {
    let campaign: Campaign
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var location: String = ""

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quest Title")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)
                    TextField("Enter quest title", text: $title)
                        .font(.system(size: 16))
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)
                    ZStack(alignment: .topLeading) {
                        if desc.isEmpty {
                            Text("What is this quest about?")
                                .foregroundColor(.secondary.opacity(0.6))
                                .padding(14)
                        }
                        TextEditor(text: $desc)
                            .font(.system(size: 16))
                            .padding(10)
                            .frame(minHeight: 120)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)
                    TextField("Optional location", text: $location)
                        .font(.system(size: 16))
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                Button {
                    let loc = location.trimmingCharacters(in: .whitespaces)
                    holder.createQuest(
                        title: title,
                        desc: desc,
                        campaign: campaign,
                        location: loc.isEmpty ? nil : loc,
                        context
                    )
                    dismiss()
                } label: {
                    Text("Add Quest")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isValid ? Color.primary : Color.secondary.opacity(0.3))
                        .cornerRadius(14)
                }
                .disabled(!isValid)
            }
            .padding(24)
        }
        .navigationTitle("New Quest")
        .navigationBarTitleDisplayMode(.inline)
    }
}
