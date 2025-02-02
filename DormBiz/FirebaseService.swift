import Foundation
import FirebaseFirestore

final class FirebaseService {
    private let db = Firestore.firestore()
    
    // Fetch establishments from Firestore
    func fetchEstablishments() async throws -> [Establishment] {
        let snapshot = try await db.collection("establishments").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Establishment.self)
        }
    }
    
    // Save an establishment to Firestore.
    // If the id is nil, it will add a new document.
    func saveEstablishment(_ establishment: Establishment) async throws {
        if let id = establishment.id {
            try await db.collection("establishments").document(id).setData(from: establishment)
        } else {
            _ = try await db.collection("establishments").addDocument(from: establishment)
        }
    }
    
    // Search for establishments by an array of query terms.
    // It returns documents where the "name" is in the query array or where "tags" contains any query term.
    func searchEstablishments(query: [String]) async throws -> [Establishment] {
        // If no queries are provided, return all establishments.
        if query.isEmpty {
            return try await fetchEstablishments()
        }
        
        // Firestore 'in' operator for name (exact match) and 'arrayContainsAny' for tags.
        // Note: the 'in' operator supports up to 10 values.
        let nameQuery = db.collection("establishments")
            .whereField("name", in: query)
        let uniQuery = db.collection("establishments")
            .whereField("uni", in: query)
        let tagQuery = db.collection("establishments")
            .whereField("tags", arrayContainsAny: query)
        
        // Execute both queries concurrently.
        async let nameSnapshot = nameQuery.getDocuments()
        async let tagSnapshot = tagQuery.getDocuments()
        async let uniSnapshot = uniQuery.getDocuments()
        let (nameResult, tagResult, uniResult) = try await (nameSnapshot, tagSnapshot, uniSnapshot)
        
        let nameResults = nameResult.documents.compactMap { try? $0.data(as: Establishment.self) }
        let uniResults = uniResult.documents.compactMap { try? $0.data(as: Establishment.self) }
        let tagResults = tagResult.documents.compactMap { try? $0.data(as: Establishment.self) }
        
        // Combine the two arrays, ensuring no duplicates (by comparing the id)
        var combined = nameResults
        for establishment in tagResults {
            if !combined.contains(where: { $0.id == establishment.id }) {
                combined.append(establishment)
            }
        }

        return combined
    }
}
