//
//  PetScene.swift
//  FitChick
//
//  Created by Hendra Irawan on 24/05/26.
//

import Foundation
import SpriteKit
import SwiftUI

final class PetScene: SKScene {
    static let referenceSize = CGSize(width: 380, height: 380)
    static let referenceAspectRatio = referenceSize.width / referenceSize.height

    private let chickNode: ChickRigNode

    private var equipment: EquippedPetItems

    init(
        size: CGSize,
        equipment: EquippedPetItems = .empty
    ) {
        self.equipment = equipment
        chickNode = ChickRigNode(equipment: equipment)
        super.init(size: size)
        configureScene()
    }

    required init?(coder aDecoder: NSCoder) {
        equipment = .empty
        chickNode = ChickRigNode()
        super.init(coder: aDecoder)
        configureScene()
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        view.allowsTransparency = true
        view.backgroundColor = .clear
        view.ignoresSiblingOrder = true
        view.preferredFramesPerSecond = 60

        setupChickIfNeeded()
        layoutChick()
        chickNode.startIdleAnimation()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        layoutChick()
    }

    func setAnimation(isPlaying: Bool) {
        isPaused = !isPlaying
    }

    func updateEquipment(_ equipment: EquippedPetItems) {
        guard self.equipment != equipment else {
            return
        }

        self.equipment = equipment
        chickNode.updateEquipment(equipment)
    }

    private func configureScene() {
        backgroundColor = .clear
        scaleMode = .aspectFit
    }

    private func setupChickIfNeeded() {
        guard chickNode.parent == nil else {
            return
        }

        addChild(chickNode)
    }

    private func layoutChick() {
        guard size.width > 0, size.height > 0 else {
            return
        }

        let fittedSize = Self.referenceSize.fitted(inside: size)
        let scale = fittedSize.width / Self.referenceSize.width

        chickNode.position = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
        chickNode.setScale(scale)
    }
}

struct PetSceneView: View {
    private let isPlaying: Bool
    private let equipment: EquippedPetItems
    @State private var scene: PetScene

    init(
        equipment: EquippedPetItems = .empty,
        isPlaying: Bool = true
    ) {
        self.equipment = equipment
        self.isPlaying = isPlaying
        _scene = State(initialValue: PetScene(
            size: PetScene.referenceSize,
            equipment: equipment
        ))
    }

    var body: some View {
        SpriteView(
            scene: scene,
            options: [.allowsTransparency]
        )
        .aspectRatio(PetScene.referenceAspectRatio, contentMode: .fit)
        .background(Color.clear)
        .onAppear {
            scene.updateEquipment(equipment)
            scene.setAnimation(isPlaying: isPlaying)
        }
        .onChange(of: equipment) { _, newValue in
            scene.updateEquipment(newValue)
        }
        .onChange(of: isPlaying) { _, newValue in
            scene.setAnimation(isPlaying: newValue)
        }
        .accessibilityLabel("Pet animation")
    }
}

private extension CGSize {
    func fitted(inside availableSize: CGSize) -> CGSize {
        let widthRatio = availableSize.width / width
        let heightRatio = availableSize.height / height
        let scale = min(widthRatio, heightRatio)

        return CGSize(
            width: width * scale,
            height: height * scale
        )
    }
}
