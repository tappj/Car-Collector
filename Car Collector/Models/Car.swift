//
//  Car.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import Foundation
import FirebaseFirestore

struct Car: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var imageURL: String?
    var dateCaptured: Date
    var points: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL
        case dateCaptured
        case points
    }
    
    init(name: String, imageURL: String? = nil, dateCaptured: Date = Date(), points: Int = 10) {
        self.name = name
        self.imageURL = imageURL
        self.dateCaptured = dateCaptured
        self.points = points
    }
}
