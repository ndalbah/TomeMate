//
//  CharacterNoteDetailView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-22.
//

import SwiftUI

struct CharacterNoteDetailView: View {
    let note: Note
    @State private var appeared = false

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
                        if let lastModified = note.lastModified {
                            Text("Last modified \(lastModified.formatted(date: .abbreviated, time: .shortened))")
                                .font(.custom("IMFellEnglish-Regular", size: 12))
                                .italic()
                                .foregroundStyle(Color.tomeSepia)
                        }
                    }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    if let desc = note.desc, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contents")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 13))
                                .foregroundStyle(Color.tomeSepia)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle(note.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}

#Preview {
    //CharacterNoteDetailView(note: Note())
}
