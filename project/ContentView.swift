//
//  ContentView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

// MARK: - ContentView

// The main SwiftUI view that represents the content of the app.
struct ContentView: View {
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Boekje()
                .tabItem {
                    Image(systemName: "book.pages.fill")
                    Text("Recepten")
                }
            
            Boodschappen()
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text("Boodschappen")
                }
            
            Website()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Gezond")
                }
        }
        .tint(Color("AccentColor"))
    }
}
