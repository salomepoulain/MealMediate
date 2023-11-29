//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct CreateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var item = ReceptItem()
    
    
    var body: some View {
        
        NavigationStack {
            ReceptListView(item: item)
                .navigationTitle("Creëer recept")
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
                            withAnimation {
                                context.insert(item)
                            }
                            dismiss()
                        }, label: {
                            Text("Voeg toe")
                        })
                    }
                }
        }
        .tint(.accentColor)
    }
}

#Preview {
    CreateRecept()
        .modelContainer(for: ReceptItem.self)
}
