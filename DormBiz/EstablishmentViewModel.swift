import SwiftUI
import Combine

final class EstablishmentViewModel: ObservableObject {
    @Published var establishments: [Establishment] = []
    private let firebaseService = FirebaseService()
    
    // Assume you inject your SwiftData modelContext somehow (e.g., via environment)
    @Environment(\.modelContext) private var modelContext

    // Fetch from Firestore and update local SwiftData storage
    func syncFromCloud() async {
        do {
            let remoteEstablishments = try await firebaseService.fetchEstablishments()
            DispatchQueue.main.async {
                // Update your local establishments list (and optionally, your local SwiftData store)
                self.establishments = remoteEstablishments
                // You could also insert these into the SwiftData context if desired.
            }
        } catch {
            print("Error fetching from Firestore: \(error)")
        }
    }
    
    // Save a local establishment to both SwiftData and Firestore
    func saveEstablishment(_ establishment: Establishment) {
        // First, update SwiftData locally
        // (For example, use modelContext.insert if it's new, or simply assume the SwiftData store is already updated.)
        
        // Then push to Firestore asynchronously.
        Task {
            do {
                try await firebaseService.saveEstablishment(establishment)
                print("Saved to Firestore successfully.")
            } catch {
                print("Error saving establishment: \(error)")
            }
        }
    }
}
