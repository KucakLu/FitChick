//
//  DailyProgressSectionView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DailyProgressSectionView: View {
    let stepCount: Int
    let stepGoal: Int
    
    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 406)
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
                        HStack {
                            Text("Distance")
                                .font(AppFont.title3)
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            DailyProgressCardView(stepCount: stepCount, stepGoal: stepGoal)
                            DailyProgressCardView(stepCount: stepCount, stepGoal: 10000)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 32)
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
    DailyProgressSectionView(stepCount: 3200, stepGoal: 8000)
}
