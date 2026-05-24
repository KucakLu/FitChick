//
//  ChickRigNode.swift
//  FitChick
//
//  Created by Codex on 25/05/26.
//

import SpriteKit

final class ChickRigNode: SKNode {
    private enum TextureName {
        static let body = "body.png"
        static let head = "head.png"
        static let cockscomb = "Cockscomb.png"
        static let beak = "beak.png"
        static let beakHalf = "beakHalf.png"
        static let beakOpen = "beakOpen.png"
        static let leftEye = "leftEye.png"
        static let leftEyeHalf = "EyeLeftHalf.png"
        static let leftEyeClose = "eyeLeftClose.png"
        static let rightEye = "rightEye.png"
        static let rightEyeHalf = "EyeRightHalf.png"
        static let rightEyeClose = "eyeRightClose.png"
        static let leftFoot = "leftFeet.png"
        static let rightFoot = "rightFeet.png"
        static let leftWing = "wingLeft.png"
        static let rightWing = "wingRight.png"
    }

    private enum NodeName {
        static let rig = "chickRig"
        static let headSocket = "headSocket"
        static let faceSocket = "faceSocket"
        static let bodySocket = "bodySocket"
        static let neckSocket = "neckSocket"
        static let hatItem = "hatItem"
        static let glassesItem = "glassesItem"
        static let clothesItem = "clothesItem"
        static let scarfItem = "scarfItem"
    }

    private enum ActionKey {
        static let poseLoop = "chick-pose-loop"
    }

    private enum Animation {
        static let cycleDuration: TimeInterval = 5.2
        static let wingScale: CGFloat = 0.84
        static let footYScale: CGFloat = 0.92
        static let closedWingRotation: CGFloat = 0.18
        static let flapWingSpread: CGFloat = 0.48
        static let flapWingBeat: CGFloat = 0.18
        static let cockscombWobbleRotation: CGFloat = 0.12
        static let cockscombWobbleLift: CGFloat = 2.0
    }

    private enum Palette {
        static let featherYellow = SKColor(red: 1.0, green: 0.87, blue: 0.35, alpha: 1.0)
    }

    private enum DesignPoint {
        static let bodyPivot = CGPoint(x: 150, y: 214)
        static let bodyCenter = CGPoint(x: 150, y: 214)
        static let neckBridgeCenter = CGPoint(x: 150, y: 204)

        static let headPivot = CGPoint(x: 150, y: 185)
        static let headCenter = CGPoint(x: 150, y: 120)
        static let cockscombPivot = CGPoint(x: 150, y: 64)
        static let cockscombCenter = CGPoint(x: 150, y: 32)
        static let beakCenter = CGPoint(x: 150, y: 192)
        static let leftEyeCenter = CGPoint(x: 92, y: 128)
        static let rightEyeCenter = CGPoint(x: 208, y: 128)

        static let leftWingPivot = CGPoint(x: 62, y: 138)
        static let leftWingCenter = CGPoint(x: 48, y: 170)
        static let rightWingPivot = CGPoint(x: 238, y: 138)
        static let rightWingCenter = CGPoint(x: 252, y: 170)

        static let leftFootPivot = CGPoint(x: 108, y: 274)
        static let leftFootCenter = CGPoint(x: 107, y: 292)
        static let rightFootPivot = CGPoint(x: 202, y: 274)
        static let rightFootCenter = CGPoint(x: 202, y: 292)

        static let headSocket = CGPoint(x: 150, y: 48)
        static let faceSocket = CGPoint(x: 150, y: 132)
        static let neckSocket = CGPoint(x: 150, y: 214)
        static let bodySocket = CGPoint(x: 150, y: 214)
    }

    private static let designSize = CGSize(width: 300, height: 348)

    private let atlas = SKTextureAtlas(named: "ChickRig")

    private let motionRoot = SKNode()
    private let bodyPivot = SKNode()
    private let headPivot = SKNode()
    private let cockscombPivot = SKNode()
    private let leftWingPivot = SKNode()
    private let rightWingPivot = SKNode()
    private let leftFootPivot = SKNode()
    private let rightFootPivot = SKNode()
    private let neckBridge = SKShapeNode(ellipseOf: CGSize(width: 158, height: 52))

    private lazy var bodyArt = makeRigSprite(TextureName.body, zPosition: 0)
    private lazy var headArt = makeRigSprite(TextureName.head, zPosition: 0)
    private lazy var cockscomb = makeRigSprite(TextureName.cockscomb, zPosition: 8)
    private lazy var beak = makeRigSprite(TextureName.beak, zPosition: 12)
    private lazy var leftEye = makeRigSprite(TextureName.leftEye, zPosition: 10)
    private lazy var rightEye = makeRigSprite(TextureName.rightEye, zPosition: 10)
    private lazy var leftWingArt = makeRigSprite(TextureName.leftWing, zPosition: 0)
    private lazy var rightWingArt = makeRigSprite(TextureName.rightWing, zPosition: 0)
    private lazy var leftFootArt = makeRigSprite(TextureName.leftFoot, zPosition: 0)
    private lazy var rightFootArt = makeRigSprite(TextureName.rightFoot, zPosition: 0)

    private let headSocket = SKNode()
    private let faceSocket = SKNode()
    private let bodySocket = SKNode()
    private let neckSocket = SKNode()

    private var leftEyeTextureName = TextureName.leftEye
    private var rightEyeTextureName = TextureName.rightEye
    private var beakTextureName = TextureName.beak

    init(equipment: EquippedPetItems = .empty) {
        super.init()
        name = NodeName.rig
        setupRig()
        updateEquipment(equipment)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        name = NodeName.rig
        setupRig()
    }

    func startIdleAnimation() {
        guard motionRoot.action(forKey: ActionKey.poseLoop) == nil else {
            return
        }

        let poseLoop = SKAction.customAction(
            withDuration: Animation.cycleDuration
        ) { [weak self] _, elapsedTime in
            self?.applyPose(elapsedTime: TimeInterval(elapsedTime))
        }

        motionRoot.run(
            .repeatForever(poseLoop),
            withKey: ActionKey.poseLoop
        )
    }

    func updateEquipment(_ equipment: EquippedPetItems) {
        equip(equipment.head, in: headSocket, nodeName: NodeName.hatItem)
        equip(equipment.face, in: faceSocket, nodeName: NodeName.glassesItem)
        equip(equipment.body, in: bodySocket, nodeName: NodeName.clothesItem)
        equip(equipment.neck, in: neckSocket, nodeName: NodeName.scarfItem)
    }

    private func setupRig() {
        addChild(motionRoot)
        setupBody()
        setupFeet()
        setupWings()
        setupHead()
        applyPose(elapsedTime: 0)
    }

    private func setupBody() {
        bodyPivot.position = scenePoint(DesignPoint.bodyPivot)
        bodyPivot.zPosition = 0
        motionRoot.addChild(bodyPivot)

        bodyArt.position = relativeScenePoint(
            DesignPoint.bodyCenter,
            to: bodyPivot.position
        )
        bodyPivot.addChild(bodyArt)

        neckBridge.position = relativeScenePoint(
            DesignPoint.neckBridgeCenter,
            to: bodyPivot.position
        )
        neckBridge.fillColor = Palette.featherYellow
        neckBridge.strokeColor = .clear
        neckBridge.lineWidth = 0
        neckBridge.zPosition = 5
        bodyPivot.addChild(neckBridge)

        bodySocket.name = NodeName.bodySocket
        bodySocket.position = relativeScenePoint(
            DesignPoint.bodySocket,
            to: bodyPivot.position
        )
        bodySocket.zPosition = 6
        bodyPivot.addChild(bodySocket)
    }

    private func setupFeet() {
        setupBodyPart(
            pivot: leftFootPivot,
            art: leftFootArt,
            pivotPoint: DesignPoint.leftFootPivot,
            artCenter: DesignPoint.leftFootCenter,
            zPosition: -8
        )
        leftFootArt.yScale = Animation.footYScale

        setupBodyPart(
            pivot: rightFootPivot,
            art: rightFootArt,
            pivotPoint: DesignPoint.rightFootPivot,
            artCenter: DesignPoint.rightFootCenter,
            zPosition: -8
        )
        rightFootArt.yScale = Animation.footYScale
    }

    private func setupWings() {
        setupBodyPart(
            pivot: leftWingPivot,
            art: leftWingArt,
            pivotPoint: DesignPoint.leftWingPivot,
            artCenter: DesignPoint.leftWingCenter,
            zPosition: -4
        )
        leftWingArt.setScale(Animation.wingScale)

        setupBodyPart(
            pivot: rightWingPivot,
            art: rightWingArt,
            pivotPoint: DesignPoint.rightWingPivot,
            artCenter: DesignPoint.rightWingCenter,
            zPosition: -4
        )
        rightWingArt.setScale(Animation.wingScale)
    }

    private func setupHead() {
        headPivot.position = scenePoint(DesignPoint.headPivot)
        headPivot.zPosition = 10
        motionRoot.addChild(headPivot)

        [
            (headArt, DesignPoint.headCenter),
            (leftEye, DesignPoint.leftEyeCenter),
            (rightEye, DesignPoint.rightEyeCenter),
            (beak, DesignPoint.beakCenter)
        ].forEach { sprite, point in
            sprite.position = relativeScenePoint(point, to: headPivot.position)
            headPivot.addChild(sprite)
        }

        let cockscombBasePosition = scenePoint(DesignPoint.cockscombPivot)
        cockscombPivot.position = relativeScenePoint(
            DesignPoint.cockscombPivot,
            to: headPivot.position
        )
        cockscombPivot.zPosition = 8
        headPivot.addChild(cockscombPivot)

        cockscomb.position = relativeScenePoint(
            DesignPoint.cockscombCenter,
            to: cockscombBasePosition
        )
        cockscomb.zPosition = 0
        cockscombPivot.addChild(cockscomb)

        configureSocket(
            headSocket,
            name: NodeName.headSocket,
            designPoint: DesignPoint.headSocket,
            zPosition: 30,
            parent: headPivot
        )
        configureSocket(
            faceSocket,
            name: NodeName.faceSocket,
            designPoint: DesignPoint.faceSocket,
            zPosition: 22,
            parent: headPivot
        )
        configureSocket(
            neckSocket,
            name: NodeName.neckSocket,
            designPoint: DesignPoint.neckSocket,
            zPosition: 24,
            parent: headPivot
        )
    }

    private func setupBodyPart(
        pivot: SKNode,
        art: SKSpriteNode,
        pivotPoint: CGPoint,
        artCenter: CGPoint,
        zPosition: CGFloat
    ) {
        pivot.position = scenePoint(pivotPoint)
        pivot.zPosition = zPosition
        art.position = relativeScenePoint(artCenter, to: pivot.position)
        pivot.addChild(art)
        motionRoot.addChild(pivot)
    }

    private func configureSocket(
        _ socket: SKNode,
        name: String,
        designPoint: CGPoint,
        zPosition: CGFloat,
        parent: SKNode
    ) {
        socket.name = name
        socket.position = relativeScenePoint(designPoint, to: parent.position)
        socket.zPosition = zPosition
        parent.addChild(socket)
    }

    private func equip(
        _ item: EquippedPetItem?,
        in socket: SKNode,
        nodeName: String
    ) {
        socket.removeAllChildren()

        guard let item else {
            return
        }

        let layout = ChickEquipmentLayout.layout(for: item)
        let texture = SKTexture(imageNamed: item.assetName)
        texture.filteringMode = .linear

        let itemNode = SKSpriteNode(texture: texture)
        itemNode.name = nodeName
        itemNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        itemNode.position = layout.offset
        itemNode.size = layout.size
        itemNode.zRotation = layout.rotation
        socket.addChild(itemNode)
    }

    private func applyPose(elapsedTime: TimeInterval) {
        let cycleProgress = normalizedProgress(
            elapsedTime,
            duration: Animation.cycleDuration
        )
        let breath = sin(cycleProgress * .pi * 2)
        let slowSway = sin((cycleProgress * .pi * 2) - 0.35)
        let chirp = easedPulse(cycleProgress, start: 0.42, end: 0.76)
        let flap = sin(normalizedWindow(cycleProgress, start: 0.42, end: 0.76) * .pi * 5)
        let crouch = max(
            easedPulse(cycleProgress, start: 0.34, end: 0.46),
            easedPulse(cycleProgress, start: 0.76, end: 0.9) * 0.7
        )
        let settle = easedPulse(cycleProgress, start: 0.76, end: 1.0)
        let coreVerticalOffset = -crouch * 4.2 + chirp * 1.8

        motionRoot.position = CGPoint(
            x: slowSway * 2.2,
            y: breath * 2.2 - crouch * 5 + chirp * 15 - settle * 2
        )
        motionRoot.zRotation = slowSway * 0.012 + chirp * 0.045
        motionRoot.setScale(1)

        let bodyBasePosition = scenePoint(DesignPoint.bodyPivot)
        bodyPivot.position = CGPoint(
            x: bodyBasePosition.x,
            y: bodyBasePosition.y + coreVerticalOffset
        )
        bodyPivot.zRotation = slowSway * 0.014 + chirp * 0.04
        bodyPivot.xScale = 1 + breath * 0.005 + crouch * 0.026 + chirp * 0.018
        bodyPivot.yScale = 1 - breath * 0.004 + crouch * 0.018 + chirp * 0.012

        let headBasePosition = scenePoint(DesignPoint.headPivot)
        headPivot.position = CGPoint(
            x: headBasePosition.x + slowSway * 0.9,
            y: headBasePosition.y + coreVerticalOffset + breath * 0.2
        )
        headPivot.zRotation = bodyPivot.zRotation + slowSway * 0.004 + chirp * 0.006

        let cockscombWobble = sin((cycleProgress * .pi * 4) + 0.7)
        cockscombPivot.zRotation = -(headPivot.zRotation * 0.65)
            + cockscombWobble * Animation.cockscombWobbleRotation
            + chirp * 0.08
        cockscombPivot.yScale = 1 + abs(cockscombWobble) * 0.025 + chirp * 0.035
        cockscombPivot.position = CGPoint(
            x: relativeScenePoint(
                DesignPoint.cockscombPivot,
                to: headBasePosition
            ).x + slowSway * 0.35,
            y: relativeScenePoint(
                DesignPoint.cockscombPivot,
                to: headBasePosition
            ).y + cockscombWobble * Animation.cockscombWobbleLift
        )

        leftWingPivot.position = scenePoint(DesignPoint.leftWingPivot)
        rightWingPivot.position = scenePoint(DesignPoint.rightWingPivot)
        let wingSpread = chirp * Animation.flapWingSpread
        let wingBeat = flap * chirp * Animation.flapWingBeat
        leftWingPivot.zRotation = Animation.closedWingRotation - wingSpread + wingBeat
        rightWingPivot.zRotation = -Animation.closedWingRotation + wingSpread - wingBeat

        leftFootPivot.position = CGPoint(
            x: scenePoint(DesignPoint.leftFootPivot).x - crouch * 2 + chirp * 1,
            y: scenePoint(DesignPoint.leftFootPivot).y + crouch * 5 - chirp * 1.5
        )
        leftFootPivot.zRotation = -0.015 - crouch * 0.16 + chirp * 0.05

        rightFootPivot.position = CGPoint(
            x: scenePoint(DesignPoint.rightFootPivot).x + crouch * 2 + chirp * 2,
            y: scenePoint(DesignPoint.rightFootPivot).y + crouch * 5 + chirp * 5
        )
        rightFootPivot.zRotation = 0.02 + crouch * 0.16 + chirp * 0.12

        applyExpression(cycleProgress: cycleProgress)
    }

    private func applyExpression(cycleProgress: CGFloat) {
        let eyesClosed = cycleProgress < 0.23 || (cycleProgress > 0.88 && cycleProgress < 0.93)
        let eyesHalf = (cycleProgress >= 0.23 && cycleProgress < 0.29)
            || (cycleProgress >= 0.93 && cycleProgress < 0.96)

        if eyesClosed {
            setEyeTextures(
                left: TextureName.leftEyeClose,
                right: TextureName.rightEyeClose
            )
        } else if eyesHalf {
            setEyeTextures(
                left: TextureName.leftEyeHalf,
                right: TextureName.rightEyeHalf
            )
        } else {
            setEyeTextures(
                left: TextureName.leftEye,
                right: TextureName.rightEye
            )
        }

        switch cycleProgress {
        case 0.48..<0.54, 0.64..<0.70:
            setBeakTexture(TextureName.beakHalf)
        case 0.54..<0.64:
            setBeakTexture(TextureName.beakOpen)
        default:
            setBeakTexture(TextureName.beak)
        }
    }

    private func setEyeTextures(left: String, right: String) {
        if leftEyeTextureName != left {
            leftEye.texture = rigTexture(left)
            leftEyeTextureName = left
        }

        if rightEyeTextureName != right {
            rightEye.texture = rigTexture(right)
            rightEyeTextureName = right
        }
    }

    private func setBeakTexture(_ textureName: String) {
        guard beakTextureName != textureName else {
            return
        }

        beak.texture = rigTexture(textureName)
        beakTextureName = textureName
    }

    private func normalizedProgress(
        _ elapsedTime: TimeInterval,
        duration: TimeInterval
    ) -> CGFloat {
        guard duration > 0 else {
            return 0
        }

        return CGFloat(elapsedTime.truncatingRemainder(dividingBy: duration) / duration)
    }

    private func normalizedWindow(
        _ progress: CGFloat,
        start: CGFloat,
        end: CGFloat
    ) -> CGFloat {
        guard end > start else {
            return 0
        }

        return min(max((progress - start) / (end - start), 0), 1)
    }

    private func easedPulse(
        _ progress: CGFloat,
        start: CGFloat,
        end: CGFloat
    ) -> CGFloat {
        let value = normalizedWindow(progress, start: start, end: end)
        return sin(value * .pi)
    }

    private func makeRigSprite(
        _ textureName: String,
        zPosition: CGFloat
    ) -> SKSpriteNode {
        let texture = rigTexture(textureName)
        let sprite = SKSpriteNode(texture: texture)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.zPosition = zPosition
        return sprite
    }

    private func rigTexture(_ textureName: String) -> SKTexture {
        let texture = atlas.textureNamed(textureName)
        texture.filteringMode = .linear
        return texture
    }

    private func scenePoint(_ designPoint: CGPoint) -> CGPoint {
        CGPoint(
            x: designPoint.x - Self.designSize.width / 2,
            y: Self.designSize.height / 2 - designPoint.y
        )
    }

    private func relativeScenePoint(
        _ designPoint: CGPoint,
        to parentPoint: CGPoint
    ) -> CGPoint {
        let point = scenePoint(designPoint)

        return CGPoint(
            x: point.x - parentPoint.x,
            y: point.y - parentPoint.y
        )
    }

}

private struct ChickEquipmentLayout {
    let size: CGSize
    let offset: CGPoint
    let rotation: CGFloat

    static func layout(for item: EquippedPetItem) -> ChickEquipmentLayout {
        switch item.category {
        case .head:
            return headLayout(for: item.assetName)
        case .face:
            return Self(
                size: CGSize(width: 126, height: 50),
                offset: .zero,
                rotation: 0
            )
        case .body:
            return Self(
                size: CGSize(width: 150, height: 112),
                offset: CGPoint(x: 0, y: 0),
                rotation: 0
            )
        case .neck:
            return Self(
                size: CGSize(width: 96, height: 84),
                offset: CGPoint(x: 0, y: -8),
                rotation: 0
            )
        }
    }

    private static func headLayout(for assetName: String) -> ChickEquipmentLayout {
        switch assetName {
        case "black_hat":
            return Self(
                size: CGSize(width: 104, height: 76),
                offset: CGPoint(x: 0, y: 0),
                rotation: 0
            )
        case "headband":
            return Self(
                size: CGSize(width: 132, height: 116),
                offset: CGPoint(x: 0, y: -22),
                rotation: 0
            )
        default:
            return Self(
                size: CGSize(width: 112, height: 88),
                offset: CGPoint(x: 0, y: -4),
                rotation: 0
            )
        }
    }
}
