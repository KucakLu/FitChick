//
//  PetPreviewCard.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct PetPreviewCard: View {
    var body: some View {
        ZStack {
            Image("ShadowSpotlight")
                .offset(y: 95)

            Image("ChickIddle")
                .resizable()
                .scaledToFit()
                .frame(width: 191, height: 216)
//                .padding(.bottom, 100)
        }
    }
}

#Preview {
    PetPreviewCard()
}
