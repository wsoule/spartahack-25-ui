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
    @State private var path = [Route]()  // Navigation path tracking using Route
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
                TagSearch(tags: $tags, onSearch: { tags in
                    Task {
                        await viewModel.searchEstablishments(withTags: tags)
                    }
                })

                // Pass your fetched establishments to the EstablishmentView.
                EstablishmentView(establishments: viewModel.establishments)
                    .navigationTitle("DormBiz")
                    .toolbar {
                        Button(action: addSession) {
                            Label("Add session", systemImage: "plus")
                        }
                        Menu {
                            // Sorting options can be added here
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
            }
            .onAppear {
                Task {
                    await viewModel.syncFromCloud()
                }
            }
            // NavigationDestination for the Route enum.
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let establishment):
                    EstablishmentDetailView(establishment: establishment)
                case .edit(let establishment):
                    EditEstablishmentView(establishment: establishment)
                }
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
            location: Location(latitude: 0, longitude: 0, name: ""),
            hours: [hour1, hour2],
            description: "",
            type: .food
        )

        viewModel.saveEstablishment(newEstablishment)
    }
    
    private func addSession() {
        
        let newEstablishment = Establishment(
            name: "",
            owners: [],
            products: [],
            tags: tags,  // Use the tags array here
            uni: "",
            location: Location(latitude: 0, longitude: 0, name: ""),
            hours: [],
            description: "",
            type: .merchant
        )
        // Push the new establishment as a Route.edit value onto the navigation path.
        path = [.edit(newEstablishment)]
    }
}

#Preview {
    ContentView()
        .environmentObject(EstablishmentViewModel())
}

enum Route: Hashable {
    case detail(Establishment)
    case edit(Establishment)

    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.detail(let left), .detail(let right)):
            return left.id == right.id
        case (.edit(let left), .edit(let right)):
            return left.id == right.id
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .detail(let establishment), .edit(let establishment):
            hasher.combine(establishment.id)
        }
    }
}


