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
    
    var body: some View {
        VStack {
            Text("Main Menu")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                arView.resetGame()
                showMainMenu = false
                AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
            }) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                showHowToPlay.toggle()
                AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
            }) {
                Text("How to Play")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showHowToPlay) {
                HowToPlayView()
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(80)
                    .zIndex(1)
            }
            
            Button(action: {
                showSettings.toggle()
                AudioManager.shared.playSFX(filename: "ButtonClick2", volume: sfxVolume)
            }) {
                Text("Settings")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showSettings){
                NavigationView{
                    SettingView(customARView: arView, showSettings: $showSettings, bgmVolume: $bgmVolume, sfxVolume: $sfxVolume)
                        .background(Color.white)
                        .cornerRadius(24)
                        .padding(UIScreen.main.bounds.width*3/16)
                        .zIndex(1)
                }
            }
        }
    }
}
