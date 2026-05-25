//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import SwiftData

struct DressUpPageView: View {
    @Environment(\.dismiss) private var dismiss

    @Query private var users: [UserAccount]
    @AppStorage("coinCount") private var coinCount = 0
    @State private var stepCount = 0
    
    private var currentPetName: String {
        let savedPetName = currentUser?.petName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let savedPetName, !savedPetName.isEmpty else {
            return "Chick"
        }
        
        return savedPetName
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColor.dashboardBackground.edgesIgnoringSafeArea(.all)
            Image("Spotlight")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    DismissButton(variant: .secondary) {
                        dismiss()
                    }
                    Spacer()
                    Text("Dress Up")
                        .font(AppFont.title1Bold)
                        .foregroundStyle(AppColor.secondary500Dark)
                    Spacer()
                    SaveButton {
                        print("Save tapped")
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))

                
                Text("\(currentPetName)")
                    .font(AppFont.title3)
                    .foregroundStyle(AppColor.neutral800Text)
                
                Spacer()
                PetPreviewCard()

                ItemSectionView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    
    private var currentUser: UserAccount? {
        guard let userId = KeychainManager.shared.retrieve(key: "appleUserId") else {
            return users.first
        }
        return users.first { $0.userId == userId } ?? users.first
    }
}



#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    DressUpPageView()
        .modelContainer(container)
}
