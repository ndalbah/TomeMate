//
//  NotesView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct NotesView: View {
    @State var notes: [Note] = []
    let character: Character?
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            VStack(spacing: 14) {
                noteList
            }
            .navigationTitle("Notes")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddNoteView(character: character!)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                let set = character?.notes as? Set<Note> ?? []
                notes = set.sorted { $0.createdAt! < $1.createdAt!}
            }
        }
    }

    private var noteList: some View {
        List {
            ForEach(notes) { note in
                noteRow(for: note)
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func noteRow(for note: Note) -> some View {
        NavigationLink(destination: CharacterNoteDetailView(note: note)) {
            TomeListRow(
                title: note.title ?? "",
                subtitle: note.lastModified.map { $0.formatted(date: .abbreviated, time: .omitted) } ?? "",
            )
        }
        .buttonStyle(.plain)
        .listRowBackground(rowBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.tomeParchment.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(Color.tomeSepia.opacity(0.18), lineWidth: 0.8)
            )
            .padding(.vertical, 2)
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach {
            holder.deleteNote($0, context)
        }
    }
}

#Preview {
    //NotesView()
}
