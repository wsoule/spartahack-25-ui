import SwiftUI
import SwiftData
import CoreLocation

struct EditSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @State var establishment: Establishment
//    var isNew: Bool   Determines if this is a new establishment
    
    @StateObject private var locationManager = LocationManager() // Live location tracking
    @State private var selectedType: TypeEstablishment = .food
    @State private var selectedUniversity: String = "MSU"
    @State private var newTag: String = ""
    @State private var showingTimePopup = false
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $establishment.name)
                TextField("Description", text: $establishment.desc)
                Picker("Type", selection: $selectedType) {
                    ForEach(TypeEstablishment.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section(header: Text("Operating Hours")) {
                Button("Add Time") {
                    showingTimePopup = true
                }
                
                if establishment.hours.isEmpty {
                    Text("No hours added")
                        .foregroundColor(.gray)
                        .font(.caption)
                } else {
                    List {
                        ForEach(establishment.hours) { hour in
                            HStack {
                                Text("\(hour.day.rawValue): \(hour.openTime) - \(hour.closeTime)")
                                    .font(.caption)
                                Spacer()
                                Button(action: {
                                    deleteHour(hour)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .onDelete(perform: deleteHours)
                    }
                }
            }
            
            Section(header: Text("Tags")) {
                HStack {
                    TextField("Add tag", text: $newTag)
                    Button("Add") {
                        if !newTag.isEmpty {
                            establishment.tags.append(newTag)
                            newTag = ""
                        }
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(establishment.tags, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            
            Section(header: Text("University")) {
                Picker("Select University", selection: $selectedUniversity) {
                    Text("MSU").tag("MSU")
                    Text("UofM").tag("UofM")
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section(header: Text("Location")) {
                            HStack {
                                Text("Lat: \(establishment.location.latitude, specifier: "%.4f")")
                                Text("Long: \(establishment.location.longitude, specifier: "%.4f")")
                                Spacer()
                                Button("Here") {
                                    updateLocation()
                                }
                                .disabled(locationManager.userLocation == nil) // Disable if location isn't available
                            }
                        }
            
//            Button("Save") {
//                if isNew {
//                    modelContext.insert(establishment)
//                }
//            }
        }
        .navigationTitle("New Establishment")
        .sheet(isPresented: $showingTimePopup) {
            AddTimePopupView(isPresented: $showingTimePopup, establishment: $establishment)
        }
    }
    /// **Updates the establishment's location to the user's current coordinates**
        private func updateLocation() {
            if let userCoordinates = locationManager.userLocation {
                establishment.location = Location(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
            }
        }
    
    // MARK: - Delete Hour Methods
    private func deleteHour(_ hour: Hour) {
        if let index = establishment.hours.firstIndex(where: { $0.id == hour.id }) {
            establishment.hours.remove(at: index)
        }
    }
    
    private func deleteHours(at offsets: IndexSet) {
        establishment.hours.remove(atOffsets: offsets)
    }
}

// MARK: - Time Popup View
struct AddTimePopupView: View {
    @Binding var isPresented: Bool
    @Binding var establishment: Establishment
    
    @State private var openTime = Date()
    @State private var closeTime = Date()
    @State private var selectedDays: Set<DayOfWeek> = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Time and Days")
                    .font(.headline)
                
                HStack {
                    VStack {
                        Text("Open Time")
                        DatePicker("", selection: $openTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    Spacer()
                    VStack {
                        Text("Close Time")
                        DatePicker("", selection: $closeTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Select Days")
                        .font(.subheadline)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            Button(action: {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }) {
                                Text(day.rawValue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                
                Button("Add Time") {
                    for day in selectedDays {
                        let newHour = Hour(day: day, openTime: formatTime(openTime), closeTime: formatTime(closeTime))
                        establishment.hours.append(newHour)
                    }
                    isPresented = false
                }
                .padding()
                
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.red)
                .padding()
            }
            .padding()
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Location Fetching
extension EditSessionView {
    func fetchCurrentLocation() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if let location = locationManager.location {
            establishment.location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}

#Preview {
    EditSessionView(
        establishment: Establishment(
            name: "Test Place",
            owners: [],
            products: [],
            tags: [],
            uni: "MSU",
            location: Location(latitude: 0, longitude: 0),
            hours: [],
            desc: "Test Description",
            type: .food
        )
//        isNew: true
    )
}
