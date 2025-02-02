//
//  FirebaseService.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

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
}
