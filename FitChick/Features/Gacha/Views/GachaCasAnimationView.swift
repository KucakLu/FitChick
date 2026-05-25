//
//  GachaCasAnimationView.swift
//  FitChick
//
//  Created by Hendra Irawan on 26/05/26.
//

import SwiftUI

struct GachaCasAnimationView: View {
    let phase: CaseOpeningPhase

    init(phase: CaseOpeningPhase = .closed) {
        self.phase = phase
    }

    var body: some View {
        CaseOpeningAnimationView(phase: phase)
    }
}

#Preview {
    GachaCasAnimationView()
}
