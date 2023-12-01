//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct CreateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var recept = ReceptItem()
    
    @State private var isNameEntered: Bool = false
    @State private var isImageAdded: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ReceptListView(item: recept, isNameEntered: $isNameEntered)
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
                        Button(action: {
                            withAnimation {
                                context.insert(recept)
                            }
                            dismiss()
                        }, label: {
                            Text("Voeg toe")
                                .foregroundColor(isImageAdded ? Color.accentColor : Color.gray)
                        })
                        .disabled(!isNameEntered)
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
