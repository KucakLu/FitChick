//
//  LoginView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//


import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("ChickHappy2")
                .resizable()
                .scaledToFit()
                .frame(width: 323, height: 338)
                .padding(.bottom, 54)
            
            VStack(spacing: 24) {
                Text("Login")
                    .font(AppFont.title1Bold)
                    .foregroundColor(AppColor.neutral800Text)
                
                Text("Using your apple account\nto access the app")
                    .font(AppFont.body)
                    .foregroundColor(AppColor.neutral600Subtext)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.bottom, 40)
            
        
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization): handleAppleSignIn(authorization: authorization)
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(width: 362, height: 48)
            .clipShape(Capsule())
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.appBackground.ignoresSafeArea())
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
}

#Preview {
    LoginView()
}
