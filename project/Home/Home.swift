//
//  Home.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import Foundation
import SwiftUI

let appYellow: Color = Color(red: 244/255, green: 237/255, blue: 233/255)

struct HomeView: View {
    var body: some View {
        ZStack {
            appYellow
                .ignoresSafeArea(edges: .top)
            Text("Test")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
