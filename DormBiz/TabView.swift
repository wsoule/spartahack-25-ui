//
//  TabView.swift
//  DormBiz
//
//  Created by Chad Hildwein on 2/1/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            // Search Tab
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.blue) // Optional: Custom color for selected tab icon
    }
}

struct HomeView: View {
    var body: some View {
        ContentView()
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search Screen")
            .font(.largeTitle)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
            .font(.largeTitle)
            .padding()
    }
}



#Preview {
    MainTabView()
}
