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
                    case .success(let authResults):
                        print("Authorisation successful: \(authResults)")
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
}

#Preview {
    LoginView()
}
