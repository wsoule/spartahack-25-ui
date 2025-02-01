//
//  Establishment.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class Establishment {
    var name: String
    var owners: [User]
    var products: [Product]
    var tags: [String]
    var uni: String
    var location: Location
    var hours: [Hour]
    var desc: String
    var type: TypeEstablishment

    init(name: String, owners: [User], products: [Product], tags: [String], uni: String, location: Location, hours: [Hour] = [], desc: String, type: TypeEstablishment) {
        self.name = name
        self.owners = owners
        self.products = products
        self.tags = tags
        self.uni = uni
        self.location = location
        self.hours = hours
        self.desc = desc
        self.type = type
    }
    
}

enum TypeEstablishment: String, Codable, CaseIterable {
    case merchant = "Merchant"
    case service = "Service"
    case food = "Food"
    case other = "Other"
}
