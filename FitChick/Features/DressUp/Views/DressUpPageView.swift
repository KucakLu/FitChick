//
//  DressUpPageView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import SwiftData

struct DressUpPageView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppStateStore

    @Query private var users: [UserAccount]

    @State private var draftEquippedItems: EquippedPetItems = .empty

    private var savedEquippedItems: EquippedPetItems {
        appState.equippedPetItems.sanitizedForCurrentCatalog(
            unlockedItems: appState.unlockedItems
        )
    }

    private func initDraft() {
        PerformanceProbe.measure("DressUpInitDraft") {
            draftEquippedItems = savedEquippedItems
        }
    }

    private func discardChangesAndDismiss() {
        PerformanceProbe.event("RouteDressUpDismiss")
        dismiss()
    }

    private func saveDraftAndDismiss() {
        PerformanceProbe.measure("DressUpSaveDraft") {
            appState.setEquippedPetItems(draftEquippedItems)
        }
        PerformanceProbe.event("RouteDressUpSave")
        dismiss()
    }

    private var hasChanges: Bool {
        draftEquippedItems != savedEquippedItems
    }

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
                    DismissButton(variant: .neutral) {
                        discardChangesAndDismiss()
                    }
                    Spacer()
                    Text("Dress Up")
                        .font(AppFont.title1Bold)
                        .foregroundStyle(AppColor.secondary500Dark)
                    Spacer()
                    SaveButton(isDisabled: !hasChanges) {
                        saveDraftAndDismiss()
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))


                Text("\(currentPetName)")
                    .font(AppFont.title1Bold)

                Spacer()
                DraftPetPreviewCard(equippedItems: draftEquippedItems)

                ItemSectionView(equippedItems: $draftEquippedItems)
            }
            .onAppear {
                initDraft()
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

struct DraftPetPreviewCard: View {
    let equippedItems: EquippedPetItems

    private let cardSize = CGSize(width: 360, height: 254)
    private let petSceneSize = CGSize(width: 250, height: 305)
    private let shadowWidth: CGFloat = 300
    private let contentYOffset: CGFloat = -2

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("ShadowSpotlight")
                .resizable()
                .scaledToFit()
                .frame(width: shadowWidth)
                .offset(y: contentYOffset + 6)

            PetSceneView(equipment: equippedItems)
                .frame(width: petSceneSize.width, height: petSceneSize.height)
                .offset(y: contentYOffset)
        }
        .frame(width: cardSize.width, height: cardSize.height)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    DressUpPageView()
        .modelContainer(container)
        .environmentObject(AppStateStore.preview())
}
