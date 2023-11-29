//
//  UpdateRecept.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI

struct UpdateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var item: ReceptItem
    
    var body: some View {
        NavigationStack {
            ReceptListView(item: item)
                .navigationTitle("Weizig recept")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button (action: {
                            dismiss()
                        }, label: {
                            Text("Sluit")
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                            dismiss()
                        }, label: {
                            Text("Weizig")
                        })
                    }
                }
        }
    }
}


