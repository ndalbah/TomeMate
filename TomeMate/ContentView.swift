//
//  ContentView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-01-28.
//

import SwiftUI
import CoreData

// test

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.user != nil{
            HomeView()
        } else{
            TomeAuthView()
        }
    }
}

#Preview {
    ContentView()
}
