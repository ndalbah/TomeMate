//
//  Page2.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct Page8: View {
    @Binding var formData: CharacterFormData
    @State private var ageText: String = ""
    var body: some View {
        VStack{
            Spacer()
            Text("How old are you?")
                .font(.title)
                .bold()
                .padding()
            TextField("", text: $ageText)
                .multilineTextAlignment(.center)
                .onChange(of: ageText){ formData.age = Int(ageText) ?? 0}
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
