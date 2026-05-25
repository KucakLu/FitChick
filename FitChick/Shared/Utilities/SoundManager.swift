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
    
    private var player: AVAudioPlayer?
    
    private init() {}
    
    func playButtonSound() {
        guard let asset = NSDataAsset(name: "ButtonSfx") else {
            print("Sound assets not found: ButtonSfx")
            return
        }
        
        do {
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
            player?.prepareToPlay()
            player?.play()
        } catch {
            print ("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func playGetPetSound() {
        guard let asset = NSDataAsset(name: "GetPetSfx") else {
            print("Sound assets not found: GetPetSfx")
            return
        }
        
        do {
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
            player?.prepareToPlay()
            player?.play()
        } catch {
            print ("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func playGetRewardSound() {
        guard let asset = NSDataAsset(name: "GetRewardSfx") else {
            print("Sound assets not found: GetRewardSfx")
            return
        }
        
        do {
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
            player?.prepareToPlay()
            player?.play()
        } catch {
            print ("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
}

