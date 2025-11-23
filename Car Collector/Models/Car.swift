//
//  Car.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import Foundation
import FirebaseFirestore
import SwiftUI

enum CarCategory: String, Codable, CaseIterable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case exotic = "Exotic"
    case legendary = "Legendary"
    
    var description: String {
        switch self {
        case .common:
            return "Mass-market everyday cars"
        case .uncommon:
            return "Premium mainstream or sporty variants"
        case .rare:
            return "Luxury brands and high-performance"
        case .exotic:
            return "Exotic supercars and ultra-luxury"
        case .legendary:
            return "Hypercars, classics, one-of-a-kind"
        }
    }
    
    var color: String {
        switch self {
        case .common: return "gray"
        case .uncommon: return "blue"
        case .rare: return "purple"
        case .exotic: return "orange"
        case .legendary: return "gold"
        }
    }
}

struct Car: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var imageURL: String?
    var dateCaptured: Date
    var points: Int
    var category: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL
        case dateCaptured
        case points
        case category
    }
    
    init(name: String, imageURL: String? = nil, dateCaptured: Date = Date(), points: Int = 10, category: String? = nil) {
        self.name = name
        self.imageURL = imageURL
        self.dateCaptured = dateCaptured
        self.points = points
        self.category = category
    }
    
    var carCategory: CarCategory {
        guard let category = category else { return .common }
        return CarCategory(rawValue: category) ?? .common
    }
}
