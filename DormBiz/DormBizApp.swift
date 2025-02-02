//
//  DormBizApp.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
}

@main
struct DormBizApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Track the user's authenticatino status
    @State private var isUserLoggedIn: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Check if user is logged in on app launch
            if isUserLoggedIn {
                ContentView()
                    .onAppear {
                        if Auth.auth().currentUser != nil {
                            isUserLoggedIn = true
                        } else {
                            isUserLoggedIn = false
                        }
                    }
            } else {
                LoginView(isLoggedIn: $isUserLoggedIn)
            }
            
        }
        .modelContainer(sharedModelContainer)
    }
}
