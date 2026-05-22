//
//  LoginSheetView.swift
//  FitChick
//

import SwiftUI
import SwiftData
import AuthenticationServices

struct LoginSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let onLoginSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Login")
                .font(AppFont.title1Bold)
                .multilineTextAlignment(.center)
                .padding(.top, 32)
            
            Text("Continue with Apple and meet your\nfavorite chick!")
                .font(AppFont.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.neutral600Subtext)
                .padding(.top, 24)
                .padding(.bottom, 32)
            
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        Task { @MainActor in
                            handleAppleSignIn(authorization: authorization)
                            onLoginSuccess()
                            dismiss()
                        }
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 46)
            .clipShape(Capsule())
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
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
