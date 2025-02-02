import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var path = [Establishment]()  // Navigation path tracking
    @State private var sortOrder = SortDescriptor(\Establishment.name)
    @State private var searchText: String = ""



    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack (path: $path) {
            EstablishmentView(sort: sortOrder, searchString: searchText)
            .navigationTitle("DormBiz")
            .navigationDestination(for: Establishment.self, destination: EditEstablishmentView.init)
            .searchable(text: $searchText)
            .toolbar{
                Button("Add session", systemImage: "plus", action: addSession)
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    //                                    Picker("Sort", selection: $sortOrder) {
                    //                                        Text("Name")
                    //                                            .tag(SortDescriptor(\Session.sessionName))
                    //                                        Text("Speaker")
                    //                                            .tag(SortDescriptor(\Session.speaker))
                    //                                    }
                }
                .pickerStyle(.inline)
            }
        }
    }

    /// Creates a new session and navigates to the EditSessionView
    private func addSession() {
        let hour1 = Hour(day: .monday, openTime: "08:00 AM", closeTime: "05:00 PM")
          let hour2 = Hour(day: .tuesday, openTime: "08:00 AM", closeTime: "05:00 PM")

          modelContext.insert(hour1)
          modelContext.insert(hour2)
        let newEstablishment = Establishment(
            name: "",
            owners: [],
            products: [],
            tags: ["hello"],
            uni: "",
            location: Location(latitude: 0, longitude: 0),
            hours: [hour1, hour2, hour1],
            desc: "",
            type: .food
        )
        modelContext.insert(newEstablishment)

//        path.append(newEstablishment)  // Push to path to navigate
        path = [newEstablishment]
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Establishment.self, inMemory: true)
}
