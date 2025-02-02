import SwiftUI
import Combine

final class EstablishmentViewModel: ObservableObject {
    @Published var establishments: [Establishment] = []
    private let firebaseService = FirebaseService()
    
    // Fetch from Firestore and update local list.
    func syncFromCloud() async {
        do {
            let remoteEstablishments = try await firebaseService.fetchEstablishments()
            DispatchQueue.main.async {
                self.establishments = remoteEstablishments
            }
        } catch {
            print("Error fetching from Firestore: \(error)")
        }
    }
    
    // Save an establishment.
    func saveEstablishment(_ establishment: Establishment) {
        Task {
            do {
                try await firebaseService.saveEstablishment(establishment)
                print("Saved to Firestore successfully.")
            } catch {
                print("Error saving establishment: \(error)")
            }
        }
    }
    
    // Search for establishments by tags.
    func searchEstablishments(withTags tags: [String]) async {
        do {
            let results = try await firebaseService.searchEstablishments(query:  tags)
            DispatchQueue.main.async {
                self.establishments = results
            }
        } catch {
            print("Error searching establishments: \(error)")
        }
    }
}
