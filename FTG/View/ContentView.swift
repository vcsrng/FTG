//
//  ContentView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var customARView = CustomARView(frame: .zero)
    @State private var showInventory = false
    @State private var showSettings = false
    @State private var showJournal = false
    @State private var showGuessNow = false

    @State private var bgmVolume: Float = 1

    var body: some View {
        ZStack {
            ARContentView(arView: customARView)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("\(customARView.collectedItems.count)")
                    .font(.system(size: 104))
                Spacer()
            }.padding(.top, 80)

            VStack {
                Spacer()
                HStack {
                    // Button kiri
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showJournal.toggle()
                                }
                                AudioManager.shared.playSFX(filename: "ButtonClick", volume: customARView.sfxVolume)
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 72, height: 72)
                                    .overlay{
                                        ZStack {
                                            VStack{
                                                RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(.white.opacity(0.2))
                                                RoundedRectangle(cornerRadius: 12)
                                                    .opacity(0)
                                            }.padding(8)
                                            VStack {
                                                Image(systemName: "list.bullet.clipboard")
                                                    .font(.system(size: 40))
                                            }.foregroundColor(.black)
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 4, x: 2, y:2)
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
                                AudioManager.shared.playSFX(filename: "ButtonClick", volume: customARView.sfxVolume)
                            }) {
                                RoundedRectangle(cornerRadius: 24)
                                    .frame(width: 144, height: 144)
                                    .overlay{
                                        ZStack {
                                            VStack{
                                                RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(.white.opacity(0.2))
                                                RoundedRectangle(cornerRadius: 24)
                                                    .opacity(0)
                                            }.padding(8)
                                            VStack {
                                                Image(systemName: "sparkle.magnifyingglass")
                                                    .font(.system(size: 80))
                                                Text("Guess now!")
                                                    .font(.system(size: 20))
                                            }.foregroundColor(.black)
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 8, x: 4, y:4)
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    // Button kanan
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showSettings.toggle()
                                }
                                AudioManager.shared.playSFX(filename: "ButtonClick", volume: customARView.sfxVolume)
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 72, height: 72)
                                    .overlay{
                                        ZStack {
                                            VStack{
                                                RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(.white.opacity(0.2))
                                                RoundedRectangle(cornerRadius: 12)
                                                    .opacity(0)
                                            }.padding(8)
                                            VStack {
                                                ZStack {
                                                    Image(systemName: "gearshape")
                                                        .font(.system(size: 32))
                                                        .position(x:30, y: 46)
                                                    Image(systemName: "gearshape.2")
                                                        .font(.system(size: 32))
                                                        .position(x:42, y: 26)
                                                }
                                            }.foregroundColor(.black)
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 4, x: 2, y:2)
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
                                AudioManager.shared.playSFX(filename: "ButtonClick", volume: customARView.sfxVolume)
                            }) {
                                RoundedRectangle(cornerRadius: 24)
                                    .frame(width: 144, height: 144)
                                    .overlay{
                                        ZStack {
                                            VStack{
                                                RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(.white.opacity(0.2))
                                                RoundedRectangle(cornerRadius: 24)
                                                    .opacity(0)
                                            }.padding(8)
                                            VStack {
                                                Image(systemName: "bag")
                                                    .font(.system(size: 80))
                                                Text("Item found")
                                                    .font(.system(size: 20))
                                            }.foregroundColor(.black)
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 8, x: 4, y:4)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
                .padding(.bottom, 8)
            }

            if showInventory {
                InventoryView(inventory: customARView.inventory, showInventory: $showInventory, sfxVolume: $customARView.sfxVolume)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(80)
                    .zIndex(2)
            }

            if showSettings {
                SettingView(showSettings: $showSettings, bgmVolume: $bgmVolume, sfxVolume: $customARView.sfxVolume)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(UIScreen.main.bounds.width*3/16)
                    .zIndex(1)
            }
            
            if showJournal {
                JournalView(answerList: customARView.answerList, showJournal: $showJournal, sfxVolume: $customARView.sfxVolume)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(80)
                    .zIndex(1)
            }
            if showGuessNow {
                GuessNowView(arView: customARView)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(80)
                    .zIndex(1)
            }
        }
        .onAppear {
            AudioManager.shared.playBGM(filename: "BGM", volume: bgmVolume)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
