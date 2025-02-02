//
//  UserView.swift
//  DormBiz
//
//  Created by Chad Hildwein on 2/1/25.
//

import SwiftUI
import FirebaseAuth

struct UserView: View {
    @State private var userName: String = ""  // Bind the user's name here
    @State private var userEmail: String = "" // Bind the user's email here
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("User Profile")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // User Name
                TextField("Enter your name", text: $userName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true) // Make it non-editable for now, or allow editing if you prefer
                
                // User Email
                TextField("Enter your email", text: $userEmail)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true) // Same here for the email
                
                // Log Out Button
                Button(action: logOut) {
                    Text("Log Out")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .onAppear {
                fetchUserData()
            }
            .navigationTitle("Profile")
        }
    }

    // Function to fetch user data from Firebase
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            self.userName = user.displayName ?? "No Name"
            self.userEmail = user.email ?? "No Email"
        }
    }

    // Log out function
    func logOut() {
        do {
            try Auth.auth().signOut()
            // Handle the navigation to the login screen or home screen here
            print("User logged out")
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}



#Preview {
    UserView()
}
