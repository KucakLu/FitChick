//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding2: View {
    let onNext: () -> Void

    init(onNext: @escaping () -> Void = {}) {
        self.onNext = onNext
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
                PrimaryButton(title: "Next") {
                    onNext()
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
