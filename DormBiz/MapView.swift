//
//  MapView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), // Default to London
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var hasCenteredOnUser = false // Track if centered on user location
    @EnvironmentObject var viewModel: EstablishmentViewModel
    @State private var tags: [String] = []
    
    @State private var selectedPlace: Place? // Track selected place for sheet presentation

    var places: [Place] {
        return viewModel.establishments.map { Place(name: $0.name, coordinate: CLLocationCoordinate2D(latitude: $0.location.latitude, longitude: $0.location.longitude), establishmentID: $0.id ?? "0")}
    }

    var body: some View {
        ZStack {
            VStack
            {
                TagSearch(tags: $tags, onSearch: { tags in
                    Task {
                        await viewModel.searchEstablishments(withTags: tags)
                    }
                })
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: places) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        Button(action: {
                            selectedPlace = place
                        }) {
                            PlaceAnnotationView(title: place.name)
                        }
                    }
                }
                    .onAppear {
                        locationManager.requestLocation()
                    }
                    .onReceive(locationManager.$location) { location in
                        if let location = location, !hasCenteredOnUser {
                            region = MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                            hasCenteredOnUser = true // Set flag to prevent re-centering
                        }
                    }
        
                    .frame(height: .infinity)
                }
                .frame(height: .infinity)
                
                // Present the sheet when a place is selected
                .sheet(item: $selectedPlace) { place in
                    EstablishmentsDetailView(establishment: viewModel.establishments.filter({$0.id == place.establishmentID}).first!) // Show detail view for the selected place
                }
            }
        }
    }

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let establishmentID: String
}

    struct PlaceAnnotationView: View {
        let title: String
        
        var body: some View {
            VStack(spacing: 0) {
                Text(title)
                    .font(.callout)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(y: -5)
            }
        }
    }


// A placeholder EstablishmentsDetailView for the sheet (you can customize it later)
struct EstablishmentsDetailView: View {
    var establishment: Establishment


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

                Text("Located at: \(establishment.location.name)")
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
    MapView()
}
