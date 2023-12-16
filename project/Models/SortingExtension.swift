//
//  SortingExtension.swift
//  project
//
//  Created by Salome Poulain on 16/12/2023.
//

import Foundation
import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case naam, tijd, lekker, porties
    
    var id: SortOption { self }
    
    enum Order {
        case ascending
        case descending
    }
    
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

extension Array where Element == ReceptItem {
    
    func sort(on option: SortOption, caseInsensitive: Bool = false) -> [ReceptItem] {
        let sortedArray: [ReceptItem]
        switch option {
        case .naam:
            sortedArray = self.sorted { (item1, item2) in
                if caseInsensitive {
                    return item1.naam.lowercased() < item2.naam.lowercased()
                } else {
                    return item1.naam < item2.naam
                }
            }
        case .tijd:
            sortedArray = self.sorted(by: { $0.tijd < $1.tijd })
        case .lekker:
            sortedArray = self.sorted(by: { $0.lekker < $1.lekker })
        case .porties:
            sortedArray = self.sorted(by: { $0.porties < $1.porties })
        }
        return sortedArray
    }
    
    func sort(on options: [SortOption], orders: [SortOption.Order], caseInsensitive: Bool = false) -> [ReceptItem] {
        guard options.count == orders.count else { return self }
        
        var sortedArray = self
        for (option, order) in zip(options, orders) {
            sortedArray = sortedArray.sort(on: option, caseInsensitive: caseInsensitive)
            if order == .descending {
                sortedArray = sortedArray.reversed()
            }
        }
        return sortedArray
    }
    
    func filterRecepten(searchQuery: String, isVegaFilter: Bool, isGezondFilter: Bool) -> [ReceptItem] {
        if searchQuery.isEmpty && !isVegaFilter && !isGezondFilter {
            return self
        }
        
        return self.filter { item in
            let naamContainsQuery = item.naam.range(of: searchQuery, options: .caseInsensitive) != nil

            let ingredientNaamContainsQuery = item.ingredienten?.contains(where: { ingredient in
                ingredient.naam.range(of: searchQuery, options: .caseInsensitive) != nil
            }) ?? false

            let lekkerContainsQuery: Bool
            switch searchQuery.lowercased() {
            case "ok":
                lekkerContainsQuery = item.lekker == 1
            case "lekker":
                lekkerContainsQuery = item.lekker == 2
            case "heerlijk":
                lekkerContainsQuery = item.lekker == 3
            default:
                lekkerContainsQuery = false
            }
            
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

            return naamContainsQuery || ingredientNaamContainsQuery || isVegaQuery || isGezondQuery || lekkerContainsQuery
        }
    }
}
