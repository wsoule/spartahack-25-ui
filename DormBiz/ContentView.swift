import SwiftUI
import SwiftData
import FirebaseFirestore

// Reference to Firestore
let db = Firestore.firestore()

struct Todo: Identifiable, Codable {
    var id: String
    var title: String
    var completed: Bool
}

struct ContentView: View {
    @State private var path = [Establishment]()  // Navigation path tracking
    @State private var sortOrder = SortDescriptor(\Establishment.name)
    @State private var searchText: String = ""
    @State private var newTag: String = ""
    @State private var tags: [String] = []
    var title = ""
    
    // Use an EnvironmentObject to get the shared EstablishmentViewModel instance.
    @EnvironmentObject var viewModel: EstablishmentViewModel

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                TagSearch(tags: tags)
                // Pass your fetched establishments to the EstablishmentView.
                EstablishmentView(establishments: viewModel.establishments)
                    .navigationTitle("DormBiz")
                    // This tells NavigationStack what view to show when an Establishment is tapped.
                    .navigationDestination(for: Establishment.self) { establishment in
                        EstablishmentDetailView(establishment: establishment)
                    }
                    .toolbar {
                        Button(action: addSession) {
                            Label("Add session", systemImage: "plus")
                        }
                        Menu {
                            // Sorting options can be added here
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                        Button(action: createTodo) {
                            Label("todo", systemImage: "minus")
                        }
                    }
            }
            .onAppear {
                viewModel.fetchEstablishments()
            }
        }
    }

    private func createTodo() {
        let hour1 = Hour(day: .monday, openTime: "08:00 AM", closeTime: "05:00 PM")
        let hour2 = Hour(day: .tuesday, openTime: "08:00 AM", closeTime: "05:00 PM")
        
        let newEstablishment = Establishment(
            name: "",
            owners: [],
            products: [],
            tags: tags,  // Use the tags array here
            uni: "",
            location: Location(latitude: 0, longitude: 0),
            hours: [hour1, hour2],
            description: "",
            type: .food
        )

        viewModel.addEstablishment(newEstablishment)
    }
    
    private func addSession() {
        let hour1 = Hour(day: .monday, openTime: "08:00 AM", closeTime: "05:00 PM")
        let hour2 = Hour(day: .tuesday, openTime: "08:00 AM", closeTime: "05:00 PM")
        
        let newEstablishment = Establishment(
            name: "",
            owners: [],
            products: [],
            tags: tags,  // Use the tags array here
            uni: "",
            location: Location(latitude: 0, longitude: 0),
            hours: [hour1, hour2],
            description: "",
            type: .food
        )
        // Push the new establishment onto the navigation path.
        path = [newEstablishment]
    }
}

#Preview {
    ContentView()
        .environmentObject(EstablishmentViewModel())
}
