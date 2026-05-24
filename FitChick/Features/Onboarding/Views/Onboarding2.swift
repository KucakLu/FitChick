//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding2: View {
    let onNext: () -> Void
    let onSkip: () -> Void

    init(
        onNext: @escaping () -> Void = {},
        onSkip: @escaping () -> Void = {}
    ) {
        self.onNext = onNext
        self.onSkip = onSkip
    }

    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                Image("ChickHappy")
                Text("""
                    Collect along the way
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.title1Bold)
                Text("""
                    The more you move, 
                    the more unique items you can discover.
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.body)
                .foregroundColor(.neutral600Subtext)
                VStack(spacing: 8) {
                    PrimaryButton(title: "Next") {
                        onNext()
                    }
                    SkipButton(title: "Skip") {
                        onSkip()
                    }
                }
            }
            .padding(.bottom, 64)
            .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    Onboarding2()
}
