//
//  ContentView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var customARView = CustomARView(frame: .zero)
    @State private var showSplashScreen = true
    @State private var showMainMenu = true
    @State private var showGameEnd = false
    
    @State private var showInventory = false
    @State private var showSettings = false
    @State private var showJournal = false
    @State private var showGuessNow = false
    @State private var showProfile = false
    
    @State private var isCorrect = false
    @State private var bgmVolume: Float = 1

    var body: some View {
        Group {
            if showSplashScreen {
                SplashScreen(customARView: customARView)
            } else {
                if showMainMenu {
                    ZStack {
                        MainMenuView(arView: customARView, showMainMenu: $showMainMenu, bgmVolume: $bgmVolume, sfxVolume: $customARView.sfxVolume)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            AudioManager.shared.playBGM(filename: "BGM2", volume: bgmVolume)
                        }
                    }
                } else {
                    ZStack {
                        ARContentView(arView: customARView)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            Text("\(customARView.collectedItems.count)")
                                .font(.system(size: 104))
                            Spacer()
                        }
                        .padding(.top, 80)
                        
                        VStack {
                            // Top Button
                            HStack{
                                ZStack {
                                    // Exp progress indicator box
                                    HStack {
                                        ProgressBar(value: Float(customARView.exp) / Float((customARView.level + 4) * 20))
                                        Spacer()
                                    }
                                    .padding(.leading, 70)
                                    
                                    // Level icon button
                                    HStack{
                                        Button(action: {
                                            withAnimation {
                                                showProfile.toggle()
                                            }
                                            AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                                        }){
                                            ZStack {
                                                // Invis box
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .overlay {
                                                        ZStack {
                                                            VStack {
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .foregroundColor(.white.opacity(0.2))
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .opacity(0)
                                                            }
                                                            .padding(8)
                                                        }
                                                        .background(
                                                            Image("BrownTexture2")
                                                        )
                                                    }
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .shadow(radius: 4, x: 2, y: 2)
                                                    .opacity(0.6)
                                                // Icon + text
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .opacity(0)
                                                    .overlay {
                                                        VStack {
                                                            Image(systemName: "person.crop.circle")
                                                                .font(.system(size: 32))
                                                            Text("Level \(customARView.level)")
                                                                .font(.subheadline)
                                                        }
                                                        .foregroundColor(.black)
                                                        .padding(8)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                        Spacer()
                                    }
                                
                                }
                                .padding(.leading, 20)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                // Left buttons
                                VStack {
                                    HStack {
                                        Button(action: {
                                            withAnimation {
                                                showJournal.toggle()
                                            }
                                            AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                                        }) {
                                            ZStack {
                                                // Invis box
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .overlay {
                                                        ZStack {
                                                            VStack {
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .foregroundColor(.white.opacity(0.2))
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .opacity(0)
                                                            }
                                                            .padding(8)
                                                        }
                                                        .background(
                                                            Image("BrownTexture2")
                                                        )
                                                    }
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .shadow(radius: 4, x: 2, y: 2)
                                                    .opacity(0.4)
                                                // Icon
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .opacity(0)
                                                    .overlay {
                                                        VStack {
                                                            Image(systemName: "list.bullet.clipboard")
                                                                .font(.system(size: 40))
                                                        }
                                                        .foregroundColor(.black)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                        .padding(.leading, 20)
                                        Spacer()
                                    }
                                    .padding(.bottom, 12)
                                    
                                    HStack {
                                        Button(action: {
                                            withAnimation {
                                                showGuessNow.toggle()
                                            }
                                            AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                                        }) {
                                            // Invis box
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 144, height: 144)
                                                    .overlay {
                                                        ZStack {
                                                            VStack {
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .foregroundColor(.white.opacity(0.2))
                                                                RoundedRectangle(cornerRadius: 24)
                                                                    .opacity(0)
                                                            }
                                                            .padding(8)
                                                        }
                                                        .background(
                                                            Image("BrownTexture2")
                                                        )
                                                    }
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .shadow(radius: 8, x: 4, y: 4)
                                                    .opacity(0.4)
                                                // Icon + text
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 144, height: 144)
                                                    .opacity(0)
                                                    .overlay {
                                                        VStack {
                                                            Image(systemName: "sparkle.magnifyingglass")
                                                                .font(.system(size: 80))
                                                            Text("Guess now!")
                                                                .font(.system(size: 20))
                                                        }
                                                        .foregroundColor(.black)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                        .padding(.leading, 20)
                                        Spacer()
                                    }
                                }
                                
                                Spacer()
                                
                                // Right buttons
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation {
                                                showSettings.toggle()
                                            }
                                            AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                                        }) {
                                            ZStack{
                                                // Invis box
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .overlay {
                                                        ZStack {
                                                            VStack {
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .foregroundColor(.white.opacity(0.2))
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .opacity(0)
                                                            }
                                                            .padding(8)
                                                        }
                                                        .background(
                                                            Image("BrownTexture2")
                                                        )
                                                    }
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .shadow(radius: 4, x: 2, y: 2)
                                                    .opacity(0.4)
                                                // Icon
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 72, height: 72)
                                                    .opacity(0)
                                                    .overlay {
                                                        VStack {
                                                            ZStack {
                                                                Image(systemName: "gearshape")
                                                                    .font(.system(size: 32))
                                                                    .position(x: 30, y: 46)
                                                                Image(systemName: "gearshape.2")
                                                                    .font(.system(size: 32))
                                                                    .position(x: 42, y: 26)
                                                            }
                                                        }
                                                        .foregroundColor(.black)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                        .padding(.trailing, 20)
                                    }
                                    .padding(.bottom, 12)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                showInventory.toggle()
                                            }
                                            AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                                        }) {
                                            ZStack{
                                                // Invis box
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 144, height: 144)
                                                    .overlay {
                                                        ZStack {
                                                            VStack {
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .foregroundColor(.white.opacity(0.2))
                                                                RoundedRectangle(cornerRadius: 24)
                                                                    .opacity(0)
                                                            }
                                                            .padding(8)
                                                        }
                                                        .background(
                                                            Image("BrownTexture2")
                                                        )
                                                    }
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .shadow(radius: 8, x: 4, y: 4)
                                                    .opacity(0.4)
                                                
                                                // Icon + text
                                                RoundedRectangle(cornerRadius: 24)
                                                    .frame(width: 144, height: 144)
                                                    .opacity(0)
                                                    .overlay {
                                                        VStack {
                                                            Image(systemName: "bag")
                                                                .font(.system(size: 80))
                                                            Text("Item found")
                                                                .font(.system(size: 20))
                                                        }
                                                        .foregroundColor(.black)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                        .padding(.trailing, 20)
                                    }
                                }
                            }
                            .padding(.bottom, 8)
                        }
                        
                        if showProfile || showInventory || showSettings || showJournal || showGuessNow || showGameEnd {
                            Color.black.opacity(0.4)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    // Disable tap outside to close the popup
                                }
                        }
                        
                        if showProfile {
                            ProfileView(customARView: customARView, showProfile: $showProfile, sfxVolume: $customARView.sfxVolume)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(UIScreen.main.bounds.width * 3 / 16)
                                .zIndex(1)
                        }
                        
                        if showInventory {
                            InventoryView(inventory: customARView.inventory, showInventory: $showInventory, sfxVolume: $customARView.sfxVolume)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(80)
                                .zIndex(2)
                        }
                        
                        if showSettings {
                            SettingView(customARView: customARView, showSettings: $showSettings, bgmVolume: $bgmVolume, sfxVolume: $customARView.sfxVolume)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(UIScreen.main.bounds.width * 3 / 16)
                                .zIndex(1)
                        }
                        
                        if showJournal {
                            JournalView(customARView: customARView, showJournal: $showJournal)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(80)
                                .zIndex(1)
                        }
                        
                        if showGuessNow {
                            GuessNowView(customARView: customARView, showGuessNow: $showGuessNow, showGameEnd: $showGameEnd, isCorrect: $isCorrect)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(80)
                                .zIndex(2)
                        }
                        
                        if showGameEnd {
                            GameEndView(showMainMenu: $showMainMenu, showGameEnd: $showGameEnd, isCorrect: $isCorrect, customARView: customARView)
                                .background(Color.white)
                                .cornerRadius(24)
                                .padding(80)
                                .zIndex(3)
                        }
                    }
                    .onAppear {
                        AudioManager.shared.playBGM(filename: "BGM", volume: bgmVolume)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplashScreen = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
