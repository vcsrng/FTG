//
//  AudioManager.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    var bgmPlayer: AVAudioPlayer?
    var sfxPlayer: AVAudioPlayer?

    private init() {}

    func playBGM(filename: String, volume: Float) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }

        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1 // Loop indefinitely
            bgmPlayer?.volume = volume
            bgmPlayer?.play()
        } catch {
            print("Failed to play BGM: \(error)")
        }
    }

    func playSFX(filename: String, volume: Float) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }

        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = volume
            sfxPlayer?.play()
        } catch {
            print("Failed to play SFX: \(error)")
        }
    }

    func setBGMVolume(_ volume: Float) {
        bgmPlayer?.volume = volume
    }

    func setSFXVolume(_ volume: Float) {
        sfxPlayer?.volume = volume
    }
}
