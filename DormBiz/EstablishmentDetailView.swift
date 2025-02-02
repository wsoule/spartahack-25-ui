import SwiftUI

struct EstablishmentDetailView: View {
    let establishment: Establishment  // Establishment to display

    var body: some View {
        ScrollView {
            HStack {
                
            }
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Image(systemName: "building.fill") // default image
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(establishment.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Text("Located at: \(establishment.location)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("\(establishment.uni)")
                    .font(.subheadline)

                if !establishment.tags.isEmpty {
                    Text("Tags: \(establishment.tags.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("About")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(establishment.desc)
                        .font(.body)
                    
                    Text("Owners")
                        .font(.body).bold()
                        .padding(.top, 10)
                    ForEach(establishment.owners, id: \.id) { owner in
                        Text(owner.name)
                            .font(.body)
                    }
                }
                
                
                Divider()

                Text("Products")
                    .font(.title2)
                    .fontWeight(.semibold)
                    
                ForEach(establishment.products, id: \.id) {product in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .font(.headline)
                        Text("$\(product.cost, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                

                Divider()

                Text("Operating Hours")
                    .font(.title2)
                    .fontWeight(.semibold)
                ForEach(establishment.hours, id: \.day) { hour in
                    Text("\(hour.day): \(hour.openTime) - \(hour.closeTime)")
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(establishment.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EstablishmentDetailView(establishment: Establishment(
        name: "Chad's Café",
        owners: [User(name: "Chad Hildwein", phoneNumber: "+12317500042", email: "chad@example.com")],
        products: [Product(name: "Coffee", cost: 3.99, description: "Hello")  ],
        tags: ["Coffee", "Merchant"],
        uni: "MSU",
        location: Location(latitude: 50, longitude: 50),
        hours: [Hour(day: .monday, openTime: "8:00 AM", closeTime: "6:00 PM")],
        description: "A local favorite for coffee lovers!",
        type: .food
    ))
}

