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
                .offset(y: 130)
            
            PetAnimationView(contentMode: .fit)
//                .frame(width: 191, height: 216)
                .scaleEffect(0.82, anchor: .bottom)
        }
    }
}

#Preview {
    PetPreviewCard()
}
