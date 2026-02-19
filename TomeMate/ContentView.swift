//
//  ContentView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-01-28.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView{
            if authManager.user != nil{
                HomeView()
            } else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
