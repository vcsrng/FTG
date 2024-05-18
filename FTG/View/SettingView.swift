//
//  SettingView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct SettingView: View {
    @State private var bgmVolume: Double = 0.5
    @State private var sfxVolume: Double = 0.5

    var body: some View {
        VStack {
            Spacer()
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Divider()
            
            VStack {
                Text("BGM Volume")
                Slider(value: $bgmVolume, in: 0...1)
                    .frame(width: 600)
            }
            .padding()

            VStack {
                Text("SFX Volume")
                Slider(value: $sfxVolume, in: 0...1)
                    .frame(width: 600)
            }
            .padding()
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    SettingView()
}
