//
//  LoginView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//

import SwiftUI

struct LoginView: View {
    @State private var showLoginSheet = false
    @State private var shouldNavigateToConnectHealth = false
    @State private var navigateToConnectHealth = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.appBackground
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Image("ChickHappy2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
            .onAppear {
                showLoginSheet = true
            }
            .navigationDestination(isPresented: $navigateToConnectHealth) {
                ConnectHealthView()
            }
        }
        .sheet(isPresented: $showLoginSheet, onDismiss: {
            guard shouldNavigateToConnectHealth else { return }

            shouldNavigateToConnectHealth = false
            PerformanceProbe.event("RouteLoginToConnectHealth")
            navigateToConnectHealth = true
        }) {
            LoginSheetView {
                shouldNavigateToConnectHealth = true
            }
            .presentationDetents([.height(290), .medium])
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    LoginView()
}
