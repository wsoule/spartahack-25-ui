import SwiftUI
import CoreLocation

struct EditEstablishmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var establishment: Establishment

    @State private var selectedType: TypeEstablishment = .food
    @State private var selectedUniversity: String = "MSU"
    @State private var newTag: String = ""
    @State private var showingTimePopup = false

    // Use an existing view model provided by the environment.
    @EnvironmentObject var viewModel: EstablishmentViewModel

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
            AddTimePopupView(isPresented: $showingTimePopup, establishment: $establishment)
        }
    }
    
    private func saveEstablishment() {
        viewModel.addEstablishment(establishment)
        dismiss()
    }
    
//    // MARK: - Delete Hour Methods
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
//    // MARK: - Remove Tag Method
//    private func removeTag(_ tag: String) {
//        establishment.tags.removeAll { $0 == tag }
//    }
}
