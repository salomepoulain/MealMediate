//
//  SortingExtension.swift
//  project
//
//  Created by Salome Poulain on 16/12/2023.
//

import Foundation
import SwiftData

// MARK: - SortOption Enumeration

// Enum to represent different sorting options for ReceptItem
enum SortOption: String, CaseIterable, Identifiable {
    case naam, tijd, lekker, porties
    
    var id: SortOption { self }
    
    // Nested enum to represent sorting order
    enum Order {
        case ascending
        case descending
    }
    
    // Property to get corresponding SortDescriptor for the option
    var sortDescriptor: SortDescriptor<ReceptItem> {
        switch self {
        case .naam:
            return SortDescriptor(\ReceptItem.naam)
        case .tijd:
            return SortDescriptor(\ReceptItem.tijd)
        case .lekker:
            return SortDescriptor(\ReceptItem.lekker)
        case .porties:
            return SortDescriptor(\ReceptItem.porties)
        }
    }
}

// MARK: - Array Extension for Sorting and Filtering

extension Array where Element == ReceptItem {
    
    // Method to sort array based on a single option and order
    func sort(on option: SortOption, order: SortOption.Order, caseInsensitive: Bool = false) -> [ReceptItem] {
        var sortedArray: [ReceptItem]

        switch option {
        case .naam:
            sortedArray = self.sorted {
                caseInsensitive ? $0.naam.lowercased() < $1.naam.lowercased() : $0.naam < $1.naam
            }
        case .tijd:
            sortedArray = self.sorted(by: { $0.tijd < $1.tijd })
        case .lekker:
            sortedArray = self.sorted(by: { $0.lekker < $1.lekker })
        case .porties:
            sortedArray = self.sorted(by: { $0.porties < $1.porties })
        }

        if order == .descending {
            sortedArray.reverse()
        }

        return sortedArray
    }
    
    // Method to sort array based on multiple options and orders
    func sort(on options: [SortOption], orders: [SortOption.Order], caseInsensitive: Bool = false) -> [ReceptItem] {
        guard options.count == orders.count else { return self }

        var sortedArray = self
        for (option, order) in zip(options, orders) {
            sortedArray = sortedArray.sort(on: option, order: order, caseInsensitive: caseInsensitive)
        }
        return sortedArray
    }
    
    // Method to filter ReceptItems based on search query and filters
    func filterRecepten(searchQuery: String, isVegaFilter: Bool, isGezondFilter: Bool) -> [ReceptItem] {
        if searchQuery.isEmpty && !isVegaFilter && !isGezondFilter {
            return self
        }
        
        return self.filter { item in
            // Check if ReceptItem's name contains the search query (case-insensitive)
            let naamContainsQuery = item.naam.range(of: searchQuery, options: .caseInsensitive) != nil

            // Check if any ingredient's name contains the search query (case-insensitive)
            let ingredientNaamContainsQuery = item.ingredienten?.contains(where: { ingredient in
                ingredient.naam.range(of: searchQuery, options: .caseInsensitive) != nil
            }) ?? false

            // Check if the "lekker" property matches the search query
            let lekkerContainsQuery: Bool
            switch searchQuery.lowercased() {
            case "ok": lekkerContainsQuery = item.lekker == 1
            case "lekker": lekkerContainsQuery = item.lekker == 2
            case "heerlijk": lekkerContainsQuery = item.lekker == 3
            default: lekkerContainsQuery = false
            }
            
            // Check if ReceptItem meets the criteria for vegetarian and/or healthy filters
            let isVegaQuery: Bool
            if isVegaFilter && isGezondFilter {
                isVegaQuery = item.isVega && item.isGezond
            } else {
                isVegaQuery = item.isVega && isVegaFilter
            }

            let isGezondQuery: Bool
            if isVegaFilter && isGezondFilter {
                isGezondQuery = item.isVega && item.isGezond
            } else {
                isGezondQuery = item.isGezond && isGezondFilter
            }

            // Return true if any of the conditions are met
            return naamContainsQuery || ingredientNaamContainsQuery || isVegaQuery || isGezondQuery || lekkerContainsQuery
        }
    }
}
