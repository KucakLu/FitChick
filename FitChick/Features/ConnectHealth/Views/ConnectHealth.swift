//
//  ConnectHealth.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import SwiftUI

struct ConnectHealth: View {
    
    @State private var stepCount: Double = 0
    
    let healthStore = HealthStore()
    
    var body: some View {
        ZStack {
            Color.secondary0Surface
                .ignoresSafeArea()
            VStack{
                Text("Connect your health")
                    .font(AppFont.largeTitleBold)
                    .padding(.bottom, 150)
                Image("Health")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 174, height: 174)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.secondary400Border, lineWidth: 8)
                    )
                    .padding(.bottom, 100)
                Text("Enable Health permissions to sync your activity and movement data.")
                    .font(AppFont.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)
                Text("Your data stays private and secure.")
                    .font(AppFont.body)
                    .padding(.bottom, 20)
                PrimaryButton(title: "Allow Access") {
                    requestHealthKitAccess()
                }
            }
            .padding(.horizontal, 30)
        }
    }
    
    func requestHealthKitAccess() {
        healthStore.requestAuthorization { success, error in
            if success {
                healthStore.fetchStepCount { steps, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        stepCount = steps
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ConnectHealth()
}
