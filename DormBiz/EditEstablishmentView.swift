import SwiftUI
import CoreLocation

struct EditEstablishmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Accept the establishment as an ObservedObject
    @ObservedObject var establishment: Establishment

    @State private var selectedType: TypeEstablishment = .food
    @State private var selectedUniversity: String = "MSU"
    @State private var newTag: String = ""
    @State private var showingTimePopup = false

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
        establishment.uni = selectedUniversity
        viewModel.saveEstablishment(establishment)
        dismiss()
    }

    
//    private func deleteHour(_ hour: Hour) {
//        if let index = establishment.hours.firstIndex(where: { $0.day == hour.day }) {
//            establishment.hours.remove(at: index)
//        }
//    }
//
//    private func deleteHours(at offsets: IndexSet) {
//        establishment.hours.remove(atOffsets: offsets)
//    }
//    
//    private func removeTag(_ tag: String) {
//        establishment.tags.removeAll { $0 == tag }
//    }
}
