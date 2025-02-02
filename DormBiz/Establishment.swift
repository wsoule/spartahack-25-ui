//
//  Establishment.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

//import Foundation
//import SwiftData
//
//@Model
//final class Establishment {
//    var name: String
//    var owners: [User]
//    var products: [Product]
//    var tags: [String]
//    var uni: String
//    var location: Location
//    var hours: [Hour]
//    var desc: String
//    var type: TypeEstablishment
//
//    init(name: String, owners: [User], products: [Product], tags: [String], uni: String, location: Location, hours: [Hour] = [], desc: String, type: TypeEstablishment) {
//        self.name = name
//        self.owners = owners
//        self.products = products
//        self.tags = tags
//        self.uni = uni
//        self.location = location
//        self.hours = hours
//        self.desc = desc
//        self.type = type
//    }
//    
//}
//
//enum TypeEstablishment: String, Codable, CaseIterable {
//    case merchant = "Merchant"
//    case service = "Service"
//    case food = "Food"
//    case other = "Other"
//}

import Foundation
import FirebaseFirestore

struct Establishment: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var owners: [User]
    var products: [Product]
    var tags: [String]
    var uni: String
    var location: Location
    var hours: [Hour]
    var description: String
    var type: TypeEstablishment

    // Conformance to Hashable using the id property
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Establishment, rhs: Establishment) -> Bool {
        return lhs.id == rhs.id
    }
}

enum TypeEstablishment: String, Codable, CaseIterable {
    case merchant = "Merchant"
    case service = "Service"
    case food = "Food"
    case other = "Other"
}

