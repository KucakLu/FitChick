//
//  SoundManager.swift
//  FitChick
//
//  Created by fajari bagas on 25/05/26.
//

import Foundation
import AVFoundation
import SwiftUI

final class SoundManager {
    static let shared = SoundManager()

    private enum SoundEffect: String, CaseIterable {
        case button = "ButtonSfx"
        case getPet = "GetPetSfx"
        case getReward = "GetRewardSfx"
    }

    private var players: [SoundEffect: AVAudioPlayer] = [:]

    private init() {}

    func preload() {
        PerformanceProbe.measure("SoundPreload") {
            SoundEffect.allCases.forEach { effect in
                _ = player(for: effect)
            }
        }
    }

    func playButtonSound() {
        PerformanceProbe.measure("SoundButton") {
            play(.button)
        }
    }

    func playGetPetSound() {
        PerformanceProbe.measure("SoundGetPet") {
            play(.getPet)
        }
    }

    func playGetRewardSound() {
        PerformanceProbe.measure("SoundGetReward") {
            play(.getReward)
        }
    }

    private func play(_ effect: SoundEffect) {
        guard let player = player(for: effect) else {
            return
        }

        if player.isPlaying {
            player.stop()
        }

        player.currentTime = 0
        player.play()
    }

    private func player(for effect: SoundEffect) -> AVAudioPlayer? {
        if let player = players[effect] {
            return player
        }

        guard let asset = NSDataAsset(name: effect.rawValue) else {
            print("Sound assets not found: \(effect.rawValue)")
            return nil
        }

        do {
            let player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
            player.prepareToPlay()
            players[effect] = player
            return player
        } catch {
            print ("Failed to play sound: \(error.localizedDescription)")
            return nil
        }
    }
}
