//
//  DressUpPageView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import SwiftData

struct DressUpPageView: View {
    @Query private var users: [UserAccount]
    @AppStorage("coinCount") private var coinCount = 0
    @AppStorage(EquippedPetItems.storageKey) private var equippedPetItemsStorage = EquippedPetItems.empty.encodedString

    @State private var draftEquippedItems: EquippedPetItems = .empty
    @State private var navigateToDashboard = false

    @Environment(\.dismiss) private var dismiss

    private var savedEquippedItems: EquippedPetItems {
        EquippedPetItems(encodedString: equippedPetItemsStorage)
            .sanitizedForCurrentCatalog
    }

    private func initDraft() {
        draftEquippedItems = savedEquippedItems
    }

    private func discardChangesAndDismiss() {
        dismiss()
    }

    private func saveDraftAndDismiss() {
        equippedPetItemsStorage = draftEquippedItems.encodedString
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

                DraftItemSectionView(
                    draftEquippedItems: $draftEquippedItems
                )
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

struct DraftItemSectionView: View {
    @Binding var draftEquippedItems: EquippedPetItems

    private let items: [CollectionItem] = CollectionData.items.filter { $0.isOwned }

    private let columns = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]

    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    Text("")
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(items) { item in
                                ItemGridButton(
                                    svgAssetName: item.svgAssetName,
                                    state: draftEquippedItems.isEquipped(item) ? .selected : .normal
                                ) {
                                    toggle(item)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                    }
                }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private func toggle(_ item: CollectionItem) {
        draftEquippedItems.toggle(item)
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

