//
//  LoginView.swift
//  DormBiz
//
//  Created by Chad Hildwein on 2/1/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: loginUser) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                // Using navigationDestination to navigate after login
                                NavigationLink("", destination: ContentView())
                                    .navigationDestination(isPresented: $isLoggedIn) {
                                        ContentView()
                                    }
            }
            .padding()
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginError = error.localizedDescription
                return
            }
            
            // Successfully logged in
            if let user = result?.user {
                print("User \(user.email ?? "") logged in")
                self.isLoggedIn = true
            }
        }
    }
}
