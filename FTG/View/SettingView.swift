//
//  SettingView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var customARView: CustomARView
    @Binding var showSettings: Bool
    @Binding var bgmVolume: Float
    @Binding var sfxVolume: Float
    @Binding var isInGame: Bool
    @State private var showMainMenu = false
    
    // harusnya state-binding
    private let bgmLobbyFiles = ["bgmLobby", "bgmLobby2", "bgmLobby3"]
    private let bgmInGameFiles = ["bgmInGame", "bgmInGame2", "bgmInGame3"]
    @State private var selectedBGMIndex = Int.random(in: 0...2)

    var body: some View {
        VStack {
            ZStack {
                Text("Settings")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showSettings.toggle()
                        }
                        AudioManager.shared.playSFX(filename: "sfxClick", volume: sfxVolume)
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .overlay{
                                ZStack{
                                    VStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white.opacity(0.2))
                                        RoundedRectangle(cornerRadius: 16)
                                            .opacity(0)
                                    }
                                    .padding(4)
                                    Image("CloseIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .shadow(radius: 4)
                                    
                                }
                            }
                            .padding(.trailing, 24)
                    }
                    .padding()
                }
            }

            VStack(alignment: .leading) {
                Text("Background Music (BGM) Volume")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)

                CustomSlider(value: $bgmVolume, icon: "speaker.wave.2.fill") {
                    AudioManager.shared.setBGMVolume(bgmVolume)
                }
                .frame(width: UIScreen.main.bounds.width * 9 / 16)
                .padding([.horizontal, .top])

                Text("Sound Effects (SFX) Volume")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)

                CustomSlider(value: $sfxVolume, icon: "speaker.wave.2.fill") {
                    AudioManager.shared.setSFXVolume(sfxVolume)
                    AudioManager.shared.playSFX(filename: "sfxClick", volume: sfxVolume)
                }
                .frame(width: UIScreen.main.bounds.width * 9 / 16)
                .padding([.horizontal, .top])
            }
            .padding(.bottom)

            Button(action: {
                AudioManager.shared.playSFX(filename: "sfxClick", volume: sfxVolume)
                if isInGame {
                    selectedBGMIndex = (selectedBGMIndex + 1) % bgmInGameFiles.count
                    AudioManager.shared.playBGM(filename: bgmInGameFiles[selectedBGMIndex], volume: bgmVolume)
                } else {
                    selectedBGMIndex = (selectedBGMIndex + 1) % bgmLobbyFiles.count
                    AudioManager.shared.playBGM(filename: bgmLobbyFiles[selectedBGMIndex], volume: bgmVolume)
                }
            }) {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 16)
                    .overlay{
                        ZStack {
                            VStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white.opacity(0.2))
                                RoundedRectangle(cornerRadius: 24)
                                    .opacity(0)
                            }
                            .padding(8)
                            
                            Text("Change BGM")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
            }
            .padding(.bottom, 40)

        }
        .background(
            Image("BrownTexture")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}

struct CustomSlider: View {
    @Binding var value: Float
    var icon: String
    var onEditingChanged: () -> Void
    @State private var thumbSize: CGFloat = 32
    @State private var lastNonZeroValue: Float = 0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let sliderRange = width - thumbSize

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: thumbSize / 2)

                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(value) * sliderRange + thumbSize / 2, height: thumbSize / 2)
                    .overlay{
                        Image("ScribbleTexture")
                            .resizable()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                HStack {
                    ZStack {
                        // Slider white circle
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: thumbSize)
                            .offset(x: CGFloat(value) * sliderRange)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newValue = min(max(0, Float(gesture.location.x / sliderRange)), 1)
                                        value = newValue
                                        onEditingChanged()
                                    }
                            )
                            .onTapGesture {
                                if value == 0 {
                                    value = lastNonZeroValue
                                } else {
                                    lastNonZeroValue = value
                                    value = 0
                                }
                                onEditingChanged()
                            }
                        // Circle strokeBorder + icon
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .frame(width: thumbSize)
                            .foregroundColor(Color.black)
                            .overlay {
                                Image(systemName: value == 0 ? "speaker.slash.fill" : icon)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .offset(x: CGFloat(value) * sliderRange)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newValue = min(max(0, Float(gesture.location.x / sliderRange)), 1)
                                        value = newValue
                                        if value != 0 {
                                            lastNonZeroValue = value
                                        }
                                        onEditingChanged()
                                    }
                            )
                            .onTapGesture {
                                if value == 0 {
                                    value = lastNonZeroValue
                                } else {
                                    lastNonZeroValue = value
                                    value = 0
                                }
                                onEditingChanged()
                            }
                    }
                }
            }
            .frame(height: thumbSize)
        }
        .frame(height: thumbSize * 1.5)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(customARView: CustomARView(frame: .zero), showSettings: .constant(true), bgmVolume: .constant(0.5), sfxVolume: .constant(0.5), isInGame: .constant(true))
    }
}
