//
//  AddNoteView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-29.
//

import SwiftUI

struct AddNoteView: View {
    let character: Character?
    @State private var title : String = ""
    @State private var content : String = ""
    @State private var currentDate: Date = Date()
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            TextField("Title", text: $title)
                .font(.title2.bold())
                .padding(.horizontal)
            Divider()
            TextEditor(text: $content)
                .font(.body)
                .padding(.horizontal)
                .overlay(alignment:.topLeading){
                    if content.isEmpty {
                        Text("Write here...")
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
                }
            Button {
                holder.createNote(
                    title: title,
                    desc: content,
                    character: character!,
                    context
                )
                dismiss()
            } label: {
                Text("Save Note")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            )
        }
                .padding(.top)
                .navigationTitle("New Note")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

#Preview {
    //AddNoteView()
}
