import Foundation
import FirebaseFirestore
import Combine
import SwiftData
import Foundation
import FirebaseFirestore
import Combine
import SwiftData

@Model
final class Establishment: ObservableObject, Identifiable, Codable, Hashable {
    // Remove @DocumentID since SwiftData’s @Model expects stored properties.
    var id: String?  // This will be non-nil for new items.
    var name: String
    var owners: [User]
    var products: [Product]
    var tags: [String]
    var uni: String
    var location: Location
    var hours: [Hour]
    var desc: String
    var type: TypeEstablishment

    // Custom initializer: if id is nil, generate a new unique id.
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
        // If no id is provided, assign a new unique value.
        self.id = id ?? UUID().uuidString
        self.name = name
        self.owners = owners
        self.products = products
        self.tags = tags
        self.uni = uni
        self.location = location
        self.hours = hours
        self.desc = description
        self.type = type
    }

    // MARK: - Codable Conformance

    enum CodingKeys: String, CodingKey {
        case id, name, owners, products, tags, uni, location, hours, desc, type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // If decoding returns nil, generate a new id.
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.owners = try container.decode([User].self, forKey: .owners)
        self.products = try container.decode([Product].self, forKey: .products)
        self.tags = try container.decode([String].self, forKey: .tags)
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
        try container.encode(owners, forKey: .owners)
        try container.encode(products, forKey: .products)
        try container.encode(tags, forKey: .tags)
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

