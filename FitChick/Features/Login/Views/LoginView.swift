//
//  LoginView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//


import SwiftUI
import SwiftData
import AuthenticationServices

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToConnectHealth = false
    
    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                Image("ChickHappy2")
                Text("""
                    Login
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.title1Bold)
                Text("Using your apple account\nto access the app")
                .multilineTextAlignment(.center)
                .font(AppFont.body)
                .foregroundColor(.neutral600Subtext)
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            handleAppleSignIn(authorization: authorization)
                            navigateToConnectHealth = true
                        case .failure(let error):
                            print("Authorisation failed: \(error.localizedDescription)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: 320, height: 46)
                .clipShape(Capsule())
            }
            .padding(.bottom, 64)
            .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $navigateToConnectHealth) {
            ConnectHealth()
        }
    }
    
    private func handleAppleSignIn(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email ?? ""
            
            KeychainManager.shared.save(key: "appleUserId", value: userId)
            if !fullName.isEmpty { KeychainManager.shared.save(key: "appleUserFullName", value: fullName) }
            if !email.isEmpty { KeychainManager.shared.save(key: "appleUserEmail", value: email) }
            getUserData()
            saveUserToSwiftData(userId: userId)
        }
    }
    
    private func getUserData() {
        let userId = KeychainManager.shared.retrieve(key: "appleUserId")
        let fullName = KeychainManager.shared.retrieve(key: "appleUserFullName")
        let email = KeychainManager.shared.retrieve(key: "appleUserEmail")
        
        print("--- USER STORAGE DATA ---")
        print("User ID: \(userId ?? "Unknown")")
        print("Full Name: \(fullName ?? "Unknown")")
        print("Email: \(email ?? "Unknown")")
    }
    
    private func saveUserToSwiftData(userId: String) {
        let descriptor = FetchDescriptor<UserAccount>(predicate: #Predicate { $0.userId == userId })
            do {
                let existingUsers = try modelContext.fetch(descriptor)
                if existingUsers.isEmpty {
                    let newUser = UserAccount(userId: userId, petName: "", totalCoint: 0)
                    modelContext.insert(newUser)
                    try modelContext.save()
                    print("New SwiftData account created for ID: \(userId)")
                } else {
                    print("Existing user detected, no new data needed.")
                }
            } catch {
                print("Failed to process SwiftData: \(error.localizedDescription)")
            }
        }
}

#Preview {
    LoginView()
}
