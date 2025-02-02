import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var path = [Establishment]()  // Navigation path tracking
    @State private var sortOrder = SortDescriptor(\Establishment.name)
    @State private var searchText: String = ""
    @State private var newTag: String = ""
    @State private var tags: [String] = []

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                // Input field and add button
                HStack {
                    TextField("Search by tag", text: $newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button("Add") {
                        addTag()
                    }
                    .disabled(newTag.isEmpty)
                }
                .padding()

                // Display tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Button(action: {
                                    removeTag(tag)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Existing content
                EstablishmentView(sort: sortOrder, searchString: searchText)
                    .navigationTitle("DormBiz")
                    .navigationDestination(for: Establishment.self, destination: EditEstablishmentView.init)
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
        }
    }

    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else { return }
        tags.append(trimmedTag)
        newTag = ""
    }

    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    private func addSession() {
        let hour1 = Hour(day: .monday, openTime: "08:00 AM", closeTime: "05:00 PM")
        let hour2 = Hour(day: .tuesday, openTime: "08:00 AM", closeTime: "05:00 PM")

        modelContext.insert(hour1)
        modelContext.insert(hour2)
        
        let newEstablishment = Establishment(
            name: "",
            owners: [],
            products: [],
            tags: tags,  // Use the tags array here
            uni: "",
            location: Location(latitude: 0, longitude: 0),
            hours: [hour1, hour2],
            desc: "",
            type: .food
        )
        modelContext.insert(newEstablishment)
        path = [newEstablishment]
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Establishment.self, inMemory: true)
}
