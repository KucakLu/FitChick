//
//  RewardAnimationRare.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 21/05/26.
//

import SwiftUI

struct RewardAnimationRare: View {
    var body: some View {
        ZStack {
            RewardBg(imageName: "RewardBgRare", scale: 1.1)
            Image("OvalRewardRare")
        }
    }
}

#Preview {
    RewardAnimationRare()
}
