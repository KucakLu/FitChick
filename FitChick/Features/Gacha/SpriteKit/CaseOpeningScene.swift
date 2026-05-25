//
//  CaseOpeningScene.swift
//  FitChick
//
//  Created by Codex on 26/05/26.
//

import SpriteKit
import SwiftUI

enum CaseOpeningPhase: Equatable {
    case closed
    case shaking
    case open
}

final class CaseOpeningScene: SKScene {
    static let referenceSize = CGSize(width: 320, height: 320)
    static let referenceAspectRatio = referenceSize.width / referenceSize.height

    private let state1Texture = SKTexture(imageNamed: "caseState1")
    private let state2Texture = SKTexture(imageNamed: "caseState2")
    private let state3Texture = SKTexture(imageNamed: "caseState3")
    private let state4Texture = SKTexture(imageNamed: "caseState4")

    private let closedNode = SKSpriteNode(imageNamed: "caseState1")
    private let openContainer = SKNode()
    private let topNode = SKSpriteNode(imageNamed: "topCaseAsset")
    private let bottomNode = SKSpriteNode(imageNamed: "bottomCaseAsset")

    private var phase: CaseOpeningPhase = .closed

    override init(size: CGSize) {
        super.init(size: size)
        configureScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureScene()
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        view.allowsTransparency = true
        view.backgroundColor = .clear
        view.ignoresSiblingOrder = true
        view.preferredFramesPerSecond = 60

        setupCaseIfNeeded()
        applyCurrentPhase()
    }

    func setPhase(_ newPhase: CaseOpeningPhase) {
        guard phase != newPhase else {
            return
        }

        phase = newPhase

        switch newPhase {
        case .closed:
            showClosedCase()
        case .shaking:
            showClosedCase()
            runActiveShakeAnimation()
        case .open:
            runOpenAnimation()
        }
    }

    private func configureScene() {
        backgroundColor = .clear
        scaleMode = .aspectFit
    }

    private func setupCaseIfNeeded() {
        guard closedNode.parent == nil else {
            return
        }

        closedNode.position = CGPoint(x: 160, y: 158)
        closedNode.zPosition = 4
        addChild(closedNode)

        topNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        topNode.position = CGPoint(x: 160, y: 128)
        topNode.zPosition = 1

        bottomNode.position = CGPoint(x: 160, y: 93)
        bottomNode.zPosition = 3

        openContainer.alpha = 0
        openContainer.isHidden = true
        openContainer.addChild(topNode)
        openContainer.addChild(bottomNode)
        addChild(openContainer)
    }

    private func applyCurrentPhase() {
        switch phase {
        case .closed:
            showClosedCase()
        case .shaking:
            showClosedCase()
            runActiveShakeAnimation()
        case .open:
            runOpenAnimation()
        }
    }

    private func showClosedCase() {
        openContainer.removeAllActions()
        topNode.removeAllActions()
        bottomNode.removeAllActions()
        openContainer.isHidden = true
        openContainer.alpha = 0

        closedNode.removeAllActions()
        closedNode.isHidden = false
        closedNode.alpha = 1
        closedNode.position = CGPoint(x: 160, y: 158)
        closedNode.zRotation = 0
        closedNode.setScale(1)
        closedNode.texture = state1Texture
        closedNode.size = state1Texture.size()
    }

    private func prepareOpenCase() {
        openContainer.removeAllActions()
        topNode.removeAllActions()
        bottomNode.removeAllActions()

        openContainer.isHidden = false
        openContainer.alpha = 0

        topNode.position = CGPoint(x: 160, y: 88)
        topNode.alpha = 0
        topNode.zRotation = -0.04
        topNode.xScale = 0.94
        topNode.yScale = 0.42

        bottomNode.position = CGPoint(x: 160, y: 93)
        bottomNode.alpha = 1
        bottomNode.setScale(0.98)
    }

    private func runActiveShakeAnimation() {
        closedNode.removeAllActions()

        let frameSequence = SKAction.sequence([
            .setTexture(state2Texture, resize: true),
            .moveBy(x: -5, y: 3, duration: 0.05),
            .setTexture(state3Texture, resize: true),
            .moveBy(x: 10, y: -2, duration: 0.06),
            .setTexture(state2Texture, resize: true),
            .moveBy(x: -10, y: 2, duration: 0.06),
            .setTexture(state3Texture, resize: true),
            .moveBy(x: 8, y: -1, duration: 0.05),
            .setTexture(state1Texture, resize: true),
            .move(to: CGPoint(x: 160, y: 158), duration: 0.08)
        ])

        closedNode.run(.repeatForever(frameSequence), withKey: "activeShake")
    }

    private func runOpenAnimation() {
        closedNode.removeAllActions()
        prepareOpenCase()

        closedNode.texture = state4Texture
        closedNode.size = state4Texture.size()
        closedNode.alpha = 1
        closedNode.isHidden = false

        openContainer.run(.fadeIn(withDuration: 0.08))

        let topOpenAction = SKAction.group([
            .fadeIn(withDuration: 0.16),
            .move(to: CGPoint(x: 160, y: 128), duration: 0.38),
            .scaleX(to: 1, y: 1, duration: 0.38),
            .rotate(toAngle: 0, duration: 0.38, shortestUnitArc: true)
        ])
        topOpenAction.timingMode = .easeOut

        let bottomBounceAction = SKAction.sequence([
            .scale(to: 1.04, duration: 0.12),
            .scale(to: 1, duration: 0.18)
        ])
        bottomBounceAction.timingMode = .easeOut

        closedNode.run(.sequence([
            .wait(forDuration: 0.08),
            .fadeOut(withDuration: 0.12),
            .hide()
        ]))

        topNode.run(.sequence([
            .wait(forDuration: 0.04),
            topOpenAction
        ]), withKey: "openTop")

        bottomNode.run(bottomBounceAction, withKey: "bottomBounce")
    }
}

struct CaseOpeningAnimationView: View {
    let phase: CaseOpeningPhase
    @State private var scene = CaseOpeningScene(size: CaseOpeningScene.referenceSize)

    var body: some View {
        SpriteView(
            scene: scene,
            options: [.allowsTransparency]
        )
        .aspectRatio(CaseOpeningScene.referenceAspectRatio, contentMode: .fit)
        .background(Color.clear)
        .onAppear {
            scene.setPhase(phase)
        }
        .onChange(of: phase) { _, newPhase in
            scene.setPhase(newPhase)
        }
        .accessibilityLabel("Case opening animation")
    }
}
