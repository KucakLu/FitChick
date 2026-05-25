//
//  DailyProgressSectionView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DailyProgressSectionView: View {
    let stepCount: Int
    let stepGoalFine: Int
    let stepGoalGood: Int
    let stepGoalExcellent: Int
    let distanceCount: Double
    let distanceGoalFine: Double
    let distanceGoalGood: Double
    let distanceGoalExcellent: Double
    
    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 354)
            .overlay(alignment: .top) {
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            Text("Your Daily Progress")
                                .font(AppFont.title1Bold)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Small steps, big changes")
                                .font(AppFont.subheadline)
                                .foregroundColor(AppColor.neutral600Subtext)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Step")
                                    .font(AppFont.title3)
                                Spacer()
                            }
                            .padding(.top, 8)
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 16) {
                                DailyProgressCardView(stepCount: stepCount, stepGoal: stepGoalFine)
                                DailyProgressCardView(stepCount: stepCount, stepGoal: stepGoalGood)
                                DailyProgressCardView(stepCount: stepCount, stepGoal: stepGoalExcellent)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 16)
                            
                            HStack {
                                Text("Distance")
                                    .font(AppFont.title3)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 16) {
                                DailyProgressCardView(distanceCount: distanceCount, distanceGoal: distanceGoalFine)
                                DailyProgressCardView(distanceCount: distanceCount, distanceGoal: distanceGoalGood)
                                DailyProgressCardView(distanceCount: distanceCount, distanceGoal: distanceGoalExcellent)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 32)
                        }
                    }
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    DailyProgressSectionView(
        stepCount: 2400,
        stepGoalFine: 8000,
        stepGoalGood: 10000,
        stepGoalExcellent: 12000,
        distanceCount: 2.3,
        distanceGoalFine: 6,
        distanceGoalGood: 8,
        distanceGoalExcellent: 10
    )
}
