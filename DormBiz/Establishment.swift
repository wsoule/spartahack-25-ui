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

    init(name: String, owners: [User], products: [Product], tags: [String], uni: String, location: Location, hours: [Hour] = []) {
        self.name = name
        self.owners = owners
        self.products = products
        self.tags = tags
        self.uni = uni
        self.location = location
        self.hours = hours
    }
}
