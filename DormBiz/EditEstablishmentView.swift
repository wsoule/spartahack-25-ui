import SwiftUI
import CoreLocation

struct EditEstablishmentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var establishment: Establishment

    @StateObject private var locationManager = LocationManager() // ✅ Initialize inside view
    @State private var selectedType: TypeEstablishment = .food
    @State private var selectedUniversity: String = "MSU"
    @State private var newTag: String = ""
    @State private var showingTimePopup = false

    var body: some View {
        Form {
            DetailsSection(establishment: $establishment, selectedType: $selectedType)
            OperatingHoursSection(
                establishment: $establishment,
                showingTimePopup: $showingTimePopup,
                deleteHour: deleteHour,
                deleteHours: deleteHours
            )
            TagsSection(
                establishment: $establishment,
                newTag: $newTag,
                removeTag: removeTag
            )
            UniversitySection(selectedUniversity: $selectedUniversity)
        }
        .navigationTitle("New Establishment")
        .sheet(isPresented: $showingTimePopup) {
            AddTimePopupView(isPresented: $showingTimePopup, establishment: $establishment)
        }
    }

    // MARK: - Update Location
//    func updateLocation() {
//        if let userCoordinates = locationManager.userLocation {
//            establishment.location = Location(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
//        }
//    }
//    // MARK: - Delete Hour Methods
//    private func deleteHour(_ hour: Hour) {
//        if let index = establishment.hours.firstIndex(where: { $0.id == hour.id }) {
//            establishment.hours.remove(at: index)
//        }
//    }
//
//    private func deleteHours(at offsets: IndexSet) {
//        establishment.hours.remove(atOffsets: offsets)
//    }
//
//    // MARK: - Remove Tag
//    private func removeTag(_ tag: String) {
//        establishment.tags.removeAll { $0 == tag }
//    }
}
