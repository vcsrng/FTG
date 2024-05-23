//
//  MainMenuView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var arView: CustomARView
    @Binding var showMainMenu: Bool
    @Binding var bgmVolume: Float
    @Binding var sfxVolume: Float
    @State private var showSettings = false
    @State private var showHowToPlay = false
    
    @State private var animateGradient: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                Image("FTG-text")
                    .resizable()
                    .frame(width: 320, height: 180)
                    .scaledToFill()
                    .padding(.bottom, 8)
                
                VStack {
                    Button(action: {
                        arView.resetGame()
                        showMainMenu = false
                        AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
                    }) {
                        RoundedRectangle(cornerRadius: 24)
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 16)
                            .overlay{
                                ZStack {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundColor(.white.opacity(0.2))
                                        RoundedRectangle(cornerRadius: 24)
                                            .opacity(0)
                                    }
                                    .padding(8)
                                    
                                    Text("Start Game")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                
                            }
                }
                }
                
                Button(action: {
                    showHowToPlay.toggle()
                    AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
                }) {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 16)
                        .overlay{
                            ZStack {
                                VStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white.opacity(0.2))
                                    RoundedRectangle(cornerRadius: 24)
                                        .opacity(0)
                                }
                                .padding(8)
                                
                                Text("How to Play")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            
                        }
                }
                
                Button(action: {
                    showSettings.toggle()
                    AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
                }) {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 16)
                        .overlay{
                            ZStack {
                                VStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white.opacity(0.2))
                                    RoundedRectangle(cornerRadius: 24)
                                        .opacity(0)
                                }
                                .padding(8)
                                
                                Text("Settings")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            
                        }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(
                Image("AdditionalBackground")
                    .resizable()
                    .frame(width: 1366, height: 1366)
                    .opacity(0.5)
            )
            if showHowToPlay{
                HowToPlayView(showHowToPlay: $showHowToPlay, sfxVolume: $sfxVolume)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(UIScreen.main.bounds.width*3/16)
                    .zIndex(1)
            }
            
            if showSettings{
                SettingView(customARView: arView, showSettings: $showSettings, bgmVolume: $bgmVolume, sfxVolume: $sfxVolume)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(UIScreen.main.bounds.width*3/16)
                    .zIndex(1)
            }
            if showSettings || showHowToPlay {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Disable tap outside to close the popup
                    }
            }
        }
        .background{
            
        }
    }
}
                      
#Preview {
    MainMenuView(arView: CustomARView(frame: .zero), showMainMenu: .constant(true), bgmVolume: .constant(1), sfxVolume: .constant(1))
}
