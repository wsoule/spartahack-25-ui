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

    var places: [Place] {
        return viewModel.establishments.map { Place(name: $0.name, coordinate: CLLocationCoordinate2D(latitude: $0.location.latitude, longitude: $0.location.longitude))}
    }

    var body: some View {
        VStack{
            TagSearch(tags: $tags, onSearch: { tags in
                Task {
                    await viewModel.searchEstablishments(withTags: tags)
                }
            })
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: places) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    PlaceAnnotationView(title: place.name)
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
    }
}
 

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct PlaceAnnotationView: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(5)
                .background(Color.blue)
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



#Preview {
    MapView()
}
