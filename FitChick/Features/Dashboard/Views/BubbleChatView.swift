//
//  BubbleChatView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct BubbleChatView: View {
    let message: String
    @State private var displayedMessage = ""

    init(message: String = "Let’s walk with me!") {
        self.message = message
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ChatBubbleTail()
                .fill(AppColor.primary50Surface)
                .frame(width: 75, height: 49)
                .offset(y: 25)

            Text(displayedMessage)
                .font(AppFont.headline)
                .foregroundColor(AppColor.labelsLight1Primary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColor.primary50Surface)
                )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .task(id: message) {
            await animateTypewriter(for: message)
        }
    }

    @MainActor
    private func animateTypewriter(for text: String) async {
        displayedMessage = ""

        for character in text {
            guard !Task.isCancelled else {
                return
            }

            displayedMessage.append(character)
            try? await Task.sleep(nanoseconds: 45_000_000)
        }
    }
}

private struct ChatBubbleTail: Shape {
    private let cornerRadius: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)

        let topLeftRadius = radius(for: topLeft, previous: bottom, next: topRight)
        let topRightRadius = radius(for: topRight, previous: topLeft, next: bottom)
        let bottomRadius = radius(for: bottom, previous: topRight, next: topLeft)

        var path = Path()
        path.move(to: point(from: topLeft, toward: topRight, distance: topLeftRadius))
        path.addLine(to: point(from: topRight, toward: topLeft, distance: topRightRadius))
        path.addQuadCurve(
            to: point(from: topRight, toward: bottom, distance: topRightRadius),
            control: topRight
        )
        path.addLine(to: point(from: bottom, toward: topRight, distance: bottomRadius))
        path.addQuadCurve(
            to: point(from: bottom, toward: topLeft, distance: bottomRadius),
            control: bottom
        )
        path.addLine(to: point(from: topLeft, toward: bottom, distance: topLeftRadius))
        path.addQuadCurve(
            to: point(from: topLeft, toward: topRight, distance: topLeftRadius),
            control: topLeft
        )
        path.closeSubpath()
        return path
    }

    private func radius(for point: CGPoint, previous: CGPoint, next: CGPoint) -> CGFloat {
        min(cornerRadius, distance(from: point, to: previous) / 2, distance(from: point, to: next) / 2)
    }

    private func point(from start: CGPoint, toward end: CGPoint, distance: CGFloat) -> CGPoint {
        let length = self.distance(from: start, to: end)

        guard length > 0 else {
            return start
        }

        let ratio = distance / length
        return CGPoint(
            x: start.x + (end.x - start.x) * ratio,
            y: start.y + (end.y - start.y) * ratio
        )
    }

    private func distance(from start: CGPoint, to end: CGPoint) -> CGFloat {
        hypot(end.x - start.x, end.y - start.y)
    }
}

#Preview {
    BubbleChatView()
}
