import Foundation
import FirebaseFirestore
import Combine
import SwiftData

@Model
final class Establishment: ObservableObject, Identifiable, Codable, Hashable {
    var id: String?  // Use this as your document ID.
    var name: String
    var nameLower: String   // Lower-case version of name.
    var owners: [User]
    var products: [Product]
    var tags: [String]
    var tagsLower: [String] // Lower-case version of tags.
    var uni: String
    var location: Location
    var hours: [Hour]
    var desc: String
    var type: TypeEstablishment

    // Custom initializer without forcing an id.
    init(
        id: String? = nil,
        name: String,
        owners: [User] = [],
        products: [Product] = [],
        tags: [String] = [],
        uni: String,
        location: Location,
        hours: [Hour] = [],
        description: String,
        type: TypeEstablishment
    ) {
        self.id = id
        self.name = name
        self.nameLower = name.lowercased()
        self.owners = owners
        self.products = products
        self.tags = tags
        self.tagsLower = tags.map { $0.lowercased() }
        self.uni = uni
        self.location = location
        self.hours = hours
        self.desc = description
        self.type = type
    }
    
    // MARK: - Codable Conformance

    enum CodingKeys: String, CodingKey {
        case id, name, nameLower, owners, products, tags, tagsLower, uni, location, hours, desc, type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameLower = try container.decode(String.self, forKey: .nameLower)
        self.owners = try container.decode([User].self, forKey: .owners)
        self.products = try container.decode([Product].self, forKey: .products)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.tagsLower = try container.decode([String].self, forKey: .tagsLower)
        self.uni = try container.decode(String.self, forKey: .uni)
        self.location = try container.decode(Location.self, forKey: .location)
        self.hours = try container.decode([Hour].self, forKey: .hours)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.type = try container.decode(TypeEstablishment.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(nameLower, forKey: .nameLower)
        try container.encode(owners, forKey: .owners)
        try container.encode(products, forKey: .products)
        try container.encode(tags, forKey: .tags)
        try container.encode(tagsLower, forKey: .tagsLower)
        try container.encode(uni, forKey: .uni)
        try container.encode(location, forKey: .location)
        try container.encode(hours, forKey: .hours)
        try container.encode(desc, forKey: .desc)
        try container.encode(type, forKey: .type)
    }
    
    // MARK: - Hashable & Equatable

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

