//
//  CharacterFormView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct CharacterFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var holder: TomeMateHolder
    @State private var formData = CharacterFormData()
    @State private var currentPage: Int = 0
    var body: some View {
        TabView(selection: $currentPage){
            Page1(formData: $formData).tag(0)
            Page2(formData: $formData).tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        // Back and forward Button and Progress View
        HStack(spacing: 5){
                Button{
                    currentPage -= 1
                }
                label:{
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)
                        .overlay{
                            Image(systemName: "chevron.left")
                                .frame(width: 20, height: 20)
                        }
                }
                .disabled(currentPage == 0)
                .padding()
            Spacer()
            ProgressView(value: Double(currentPage + 1), total: 11)
                .foregroundStyle(Color(.red))
            Spacer()
            Button{
                currentPage += 1
            }
            label:{
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 40, height: 40)
                    .overlay{
                        Image(systemName: "chevron.right")
                            .frame(width: 20, height: 20)
                    }
            }
            .padding()
        }
    }
}

#Preview {
    CharacterFormView()
}
