//
//  SettingView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct SettingView: View {
    @Binding var bgmVolume: Float
    @Binding var sfxVolume: Float

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            VStack(alignment: .leading) {
                Text("Background Music Volume")
                    .padding(.leading)
                Slider(value: Binding(
                    get: { Double(bgmVolume) },
                    set: { newValue in
                        bgmVolume = Float(newValue)
                        AudioManager.shared.setBGMVolume(bgmVolume)
                    }
                ), in: 0...1)
                .frame(width: 600)
                .padding()

                Text("Sound Effects Volume")
                    .padding(.leading)
                Slider(value: Binding(
                    get: { Double(sfxVolume) },
                    set: { newValue in
                        sfxVolume = Float(newValue)
                        AudioManager.shared.setSFXVolume(sfxVolume)
                    }
                ), in: 0...1)
                .frame(width: 600)
                .padding()
            }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(bgmVolume: .constant(0.5), sfxVolume: .constant(0.5))
    }
}
