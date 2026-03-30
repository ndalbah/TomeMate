//
//  CharacterNoteDetailView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-22.
//

import SwiftUI

struct CharacterNoteDetailView: View {
    let note: Note
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @State private var appeared = false
    @State private var isEditing = false
    @State private var editedDesc: String = ""

    var body: some View {
        ZStack {
            Color.tomeBg
                .ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title ?? "")
                            .font(.custom("Cinzel-Regular", size: 26))
                            .foregroundStyle(Color.tomeInk)
                    }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    if isEditing || !(note.desc ?? "").isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            if isEditing {
                                TextEditor(text: $editedDesc)
                                    .font(.custom("IMFellEnglish-Regular", size: 13))
                                    .foregroundStyle(Color.tomeSepia)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.tomeBg.opacity(0.5))
                                    .frame(minHeight: 160)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.tomeCrimson.opacity(0.4), lineWidth: 1)
                                    )
                            } else {
                                Text(note.desc ?? "")
                                    .font(.custom("IMFellEnglish-Regular", size: 13))
                                    .foregroundStyle(Color.tomeSepia)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }
                }
                .padding(24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            editedDesc = note.desc ?? ""
                            isEditing = false
                        }
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundStyle(Color.tomeSepia)

                        Button("Save") {
                            holder.updateNote(body: editedDesc ,note: note, context)
                            isEditing = false
                            dismiss()
                        }
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundStyle(Color.tomeCrimson)
                    }
                } else {
                    Button("Edit") {
                        editedDesc = note.desc ?? ""
                        isEditing = true
                    }
                    .font(.custom("Cinzel-Regular", size: 13))
                    .foregroundStyle(Color.tomeCrimson)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}
