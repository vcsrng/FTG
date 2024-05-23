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
    @State private var showMainMenu = false

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
                        AudioManager.shared.playSFX(filename: "ButtonClick", volume: sfxVolume)
                    }) {
                        Image(systemName: "x.square.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                            .padding()
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
                .padding()

                Text("Sound Effects (SFX) Volume")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)

                CustomSlider(value: $sfxVolume, icon: "speaker.wave.2.fill") {
                    AudioManager.shared.setSFXVolume(sfxVolume)
                }
                .frame(width: UIScreen.main.bounds.width * 9 / 16)
                .padding()
            }
            .padding(.bottom, 24)
            .padding()
        }
        .background(
            Image("BrownTexture2")
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
    @State private var isMuted: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let sliderRange = width - thumbSize

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: thumbSize / 2)

                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.black.opacity(0.8))
                    .frame(width: CGFloat(value) * sliderRange + thumbSize / 2, height: thumbSize / 2)
                    .overlay{
                        Image("ScribbleTexture")
                            .resizable()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                HStack {
                    ZStack {
                        // White circle
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: thumbSize)
                            .offset(x: CGFloat(value) * sliderRange)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newValue = min(max(0, Float(gesture.location.x / sliderRange)), 1)
                                        value = newValue
                                        isMuted = false
                                        onEditingChanged()
                                    }
                            )
                            .onTapGesture {
                                isMuted.toggle()
                                onEditingChanged()
                            }
                        // Circle stroke + icon
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .frame(width: thumbSize)
                            .foregroundColor(Color.black)
                            .overlay {
                                Image(systemName: isMuted ? "speaker.slash.fill" : icon)
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
                                        if !isMuted {
                                            onEditingChanged()
                                        }
                                    }
                            )
                            .onTapGesture {
                                isMuted.toggle()
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
        SettingView(customARView: CustomARView(frame: .zero), showSettings: .constant(true), bgmVolume: .constant(0.5), sfxVolume: .constant(0.5))
    }
}
