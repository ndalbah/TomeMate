//
//  Page1.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct Page1: View {
    @Binding var formData: CharacterFormData
    var body: some View {
        VStack{
            Spacer()
            Text("What is your name adventurer?")
                .font(.title)
                .bold()
                .padding()
            TextField("", text: $formData.name)
                .multilineTextAlignment(.center)
                .frame(width: 250)
            Rectangle()
                .frame(width: 250, height: 1)
                .foregroundStyle(Color.gray)
            Spacer()
        }
    }
}

#Preview {
    
}
