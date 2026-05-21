//
//   DailyProgressCardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DailyProgressCardView: View {
    let stepCount: Int
    let stepGoal: Int

    private var progress: Double {
        guard stepGoal > 0 else {
            return 0
        }

        return min(Double(stepCount) / Double(stepGoal), 1)
    }

    private var isComplete: Bool {
        stepGoal > 0 && stepCount >= stepGoal
    }

    private var progressStatus: String {
        if isComplete {
            return "Complete"
        }

        return "\(Int(progress * 100))%"
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("\(stepCount) / \(stepGoal) steps")
                        .font(AppFont.bodyBold)
                        .foregroundStyle(AppColor.neutral0)

                    Spacer()

                    Text(progressStatus)
                        .font(AppFont.bodyBold)
                        .foregroundStyle(AppColor.neutral0)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColor.success50Surface)

                        Capsule()
                            .fill(AppColor.success300Main)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 10)
            }

            HStack {
                Spacer()

                CollectButton(amount: 10, isDisabled: !isComplete) {
                    // Collect daily step reward.
                }
                .padding(.bottom, 8)
            }
        }
        .padding(16)
        .frame(maxWidth: 354)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.primary300Main)
        }
    }
}

#Preview {
    DailyProgressCardView(stepCount: 4200, stepGoal: 8000)
        .padding()
        .background(AppColor.secondary50Surface)
}
