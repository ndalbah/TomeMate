//
//  AddQuestLogView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct AddQuestLogView: View {
    let quest: Quest
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss

    @State private var logEntry: String = ""

    var isValid: Bool {
        !logEntry.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("Quest")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)
                    Text(quest.title ?? "Unknown Quest")
                        .font(.system(size: 18, weight: .semibold))
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Log Entry")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)

                    ZStack(alignment: .topLeading) {
                        if logEntry.isEmpty {
                            Text("What happened on this adventure?")
                                .foregroundColor(.secondary.opacity(0.6))
                                .padding(14)
                        }
                        TextEditor(text: $logEntry)
                            .font(.system(size: 16))
                            .padding(10)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                Button {
                    holder.updateQuest(log: logEntry, status: nil, quest: quest, context)
                    dismiss()
                } label: {
                    Text("Save Entry")
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
        .navigationTitle("New Log Entry")
        .navigationBarTitleDisplayMode(.inline)
    }
}
