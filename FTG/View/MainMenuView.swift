//
//  MainMenuView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var arView: CustomARView
    @Binding var showMainMenu: Bool
    @State private var showSettings = false
    @State private var showHowToPlay = false
    
    var body: some View {
        VStack {
            Text("Main Menu")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
//                arView.resetGame()
                showMainMenu = false
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
            }
            
            Button(action: {
                showSettings.toggle()
            }) {
                Text("Settings")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showSettings) {
                SettingView(showSettings: $showSettings, bgmVolume: .constant(0.5), sfxVolume: .constant(0.5))
            }
        }
    }
}
