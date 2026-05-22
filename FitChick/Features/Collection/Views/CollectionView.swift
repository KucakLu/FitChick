//
//  CollectionView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 22/05/26.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var items: [CollectionItem] = CollectionData.items.sorted { $0.isOwned && !$1.isOwned }
    @State private var navigateToDashboard = false
    
    private let columns = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
    
    private var ownedCountText: String {
        let ownedCount = items.filter { $0.isOwned }.count
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
                        navigateToDashboard = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items) { item in
                            
                            let buttonState: ItemState = item.isOwned ? .normal : .locked
                            
                            ItemGridButton(svgAssetName: item.svgAssetName, state: buttonState) {
                            }
                            .disabled(true)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDashboard) {
            DashboardView()
        }
    }
}

#Preview {
    CollectionView()
}
