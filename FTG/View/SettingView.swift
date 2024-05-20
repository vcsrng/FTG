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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
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
                Text("Background Music Volume")
                    .padding(.leading)
                Slider(value: Binding(
                    get: { Double(bgmVolume) },
                    set: { newValue in
                        bgmVolume = Float(newValue)
                        AudioManager.shared.setBGMVolume(bgmVolume)
                    }
                ), in: 0...1)
                .frame(width: UIScreen.main.bounds.width * 9 / 16)
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
                .frame(width: UIScreen.main.bounds.width * 9 / 16)
                .padding()
            }
            .padding(.bottom, 24)
//            Spacer()
//
//            Button(action: {
//                showMainMenu = true
//                showSettings = false
//            }) {
//                Text("Back to Main Menu")
//                    .font(.title2)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
            .padding()
        }
//        .fullScreenCover(isPresented: $showMainMenu) {
//            MainMenuView(arView: customARView, showMainMenu: $showMainMenu)
//        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(customARView: CustomARView(frame: .zero), showSettings: .constant(true), bgmVolume: .constant(0.5), sfxVolume: .constant(0.5))
    }
}
