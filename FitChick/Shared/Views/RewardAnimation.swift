//
//  RewardAnimation.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 21/05/26.
//

import SwiftUI

struct RewardAnimation: View {
    var body: some View {
        ZStack {
            RewardBg(scale: 1.1)
            Image("OvalReward")
        }
    }
}

#Preview {
    RewardAnimation()
}
