////
////  ContentView.swift
////  DormBiz
////
////  Created by Wyat Soule on 2/1/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @State private var path = [Establishment]()
//    @Environment(\.modelContext) private var modelContext
//    @Query private var establishments: [Establishment]
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView(path: $path) {
//            EstablishmentView()
//                .navigationTitle("DormBix")
//                .navigationDestination(for: Establishment.self, destination: EditSessionView.init)
//                .toolbar{
//                    Button("Add session", systemImage: "plus", action: addSession)
//                    }
//                    .pickerStyle(.inline)
//                }
//            }
////            List {
////                ForEach(items) { item in
////                    NavigationLink {
////                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
////                    } label: {
////                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
////                    }
////                }
////                .onDelete(perform: deleteItems)
////            }
////            .toolbar {
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    EditButton()
////                }
////                ToolbarItem {
////                    Button(action: addItem) {
////                        Label("Add Item", systemImage: "plus")
////                    }
////                }
////            }
////        } detail: {
////            Text("Select an item")
////        }
//    }
//
////    private func addItem() {
////        withAnimation {
////            let newItem = Item(timestamp: Date())
////            modelContext.insert(newItem)
////        }
////    }
////
////    private func deleteItems(offsets: IndexSet) {
////        withAnimation {
////            for index in offsets {
////                modelContext.delete(items[index])
////            }
////        }
////    }
//    private func addSession() {
//        let session = Establishment()
//           modelContext.insert(session)
//           path = [session]
//       }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
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
