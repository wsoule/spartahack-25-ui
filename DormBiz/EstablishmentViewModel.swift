//
//  EstablishmentViewModel.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI
import FirebaseFirestore

class EstablishmentViewModel: ObservableObject {
    @Published var establishments: [Establishment] = []
    private var db = Firestore.firestore()
    
    func fetchEstablishments() {
        db.collection("establishments").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            self.establishments = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Establishment.self)
            } ?? []
        }
    }
    
    func addEstablishment(_ establishment: Establishment) {
        do {
            let _ = try db.collection("establishments").addDocument(from: establishment)
        } catch {
            print("Error adding establishment: \(error.localizedDescription)")
        }
    }
}
