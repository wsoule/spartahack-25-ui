import SwiftUI
import CoreLocation
import MapKit

struct EditEstablishmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Accept the establishment as an ObservedObject
    @ObservedObject var establishment: Establishment

    @State private var selectedType: TypeEstablishment = .food
    @State private var selectedUniversity: String = "MSU"
    @State private var newTag: String = ""
    @State private var showingTimePopup = false

    // New state for map search.
    @State private var mapSearchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []

    // Use an existing view model provided by the environment.
    @EnvironmentObject var viewModel: EstablishmentViewModel

    // Computed binding that updates the properties instead of replacing the object.
    private var establishmentBinding: Binding<Establishment> {
        Binding<Establishment>(
            get: { self.establishment },
            set: { newValue in
                self.establishment.name = newValue.name
                self.establishment.owners = newValue.owners
                self.establishment.products = newValue.products
                self.establishment.tags = newValue.tags
                self.establishment.uni = newValue.uni
                self.establishment.location = newValue.location
                self.establishment.hours = newValue.hours
                self.establishment.desc = newValue.desc
                self.establishment.type = newValue.type
            }
        )
    }

    var body: some View {
        Form {
            DetailsSection(establishment: establishmentBinding, selectedType: $selectedType)
            OperatingHoursSection(
                establishment: establishmentBinding,
                showingTimePopup: $showingTimePopup,
                deleteHour: deleteHour,
                deleteHours: deleteHours
            )
            TagsSection(
                establishment: establishmentBinding,
                newTag: $newTag,
                removeTag: removeTag
            )
            UniversitySection(selectedUniversity: $selectedUniversity)
            
            // Section for Apple Maps search.
            Section(header: Text("Location Search")) {
                TextField("Search location...", text: $mapSearchQuery, onCommit: {
                    performMapSearch()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Display search results.
                ForEach(searchResults, id: \.self) { mapItem in
                    Button(action: {
                        // Update establishment.location with the selected result.
                        let coordinate = mapItem.placemark.coordinate
                        establishment.location = Location( latitude: coordinate.latitude, longitude: coordinate.longitude, name: mapItem.name ?? "unknown")
                        // Optionally clear search results.
                        searchResults = []
                        mapSearchQuery = mapItem.name ?? ""
                    }) {
                        HStack {
                            Text(mapItem.name ?? "Unknown")
                            if let title = mapItem.placemark.title {
                                Text("- \(title)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            
            // Save button at the bottom
            Section {
                Button(action: saveEstablishment) {
                    Text("Save")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("New Establishment")
        .sheet(isPresented: $showingTimePopup) {
            AddTimePopupView(isPresented: $showingTimePopup, establishment: establishmentBinding)
        }
    }
    
    private func saveEstablishment() {
        // Ensure the selected university is saved.
        establishment.uni = selectedUniversity
        viewModel.saveEstablishment(establishment)
        dismiss()
    }
    

    
    // Use MKLocalSearch to perform the Apple Maps search.
    private func performMapSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = mapSearchQuery
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching Apple Maps: \(error)")
                return
            }
            if let mapItems = response?.mapItems {
                DispatchQueue.main.async {
                    self.searchResults = mapItems
                }
            }
        }
    }
}
