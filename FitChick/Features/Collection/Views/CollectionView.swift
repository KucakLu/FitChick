//
//  CollectionView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 22/05/26.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var appState: AppStateStore
    
    private var items: [CollectionItem] {
        CollectionData.items.sorted {
            CollectionData.isItemOwned($0, unlockedItems: appState.unlockedItems)
                && !CollectionData.isItemOwned($1, unlockedItems: appState.unlockedItems)
        }
    }
    
    private let columns = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
    
    private var ownedCountText: String {
        let ownedCount = items.filter {
            CollectionData.isItemOwned($0, unlockedItems: appState.unlockedItems)
        }.count
        return "\(ownedCount)/\(items.count)"
    }
    
    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    DismissButton(variant: .neutral) {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text(ownedCountText)
                        .font(AppFont.title1Bold)
                        .foregroundColor(AppColor.secondary500Dark)
                    
                    Spacer()
                    
                    IconButton(icon: Image(systemName: "house.fill")) {
                        PerformanceProbe.event("RouteCollectionToDashboard")
                        router.showDashboard()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items) { item in
                            
                            let isUnlocked = CollectionData.isItemOwned(
                                item,
                                unlockedItems: appState.unlockedItems
                            )
                            let buttonState: ItemState = isUnlocked ? .normal : .locked
                            
                            ItemGridButton(svgAssetName: item.svgAssetName, state: buttonState) {
                            }
                            .disabled(!isUnlocked) 
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CollectionView()
        .environmentObject(AppRouter())
        .environmentObject(AppStateStore.preview())
}
