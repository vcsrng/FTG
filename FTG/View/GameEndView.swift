//
//  GameEndView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct GameEndView: View {
    @Binding var showMainMenu: Bool
    @Binding var showGameEnd: Bool
    @Binding var isCorrect: Bool
    @ObservedObject var customARView: CustomARView

    var body: some View {
        VStack {
            VStack {
                Text(isCorrect ? "Congratulations!" : "Unfortunately")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding(.bottom, -32)
                Text(isCorrect ? "You guessed correctly!" : "Your guess was incorrect.")
                    .font(.title)
                Text(isCorrect ? "Experience +5" : "Experience +0")
                    .font(.title2)
                    .padding(.top, 8)
            }
            .padding()
            .padding(.vertical)
            .padding(.bottom, 8)
            
            HStack {
                Button(action: {
                    AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                    showMainMenu = true
                    showGameEnd = false
                }) {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 24)
                        .overlay {
                            ZStack {
                                VStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white.opacity(0.2))
                                    RoundedRectangle(cornerRadius: 24)
                                        .opacity(0)
                                }
                                .padding(8)
                                
                                Text("Main Menu")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                }.padding(.trailing, 32)
                
                Button(action: {
                    AudioManager.shared.playSFX(filename: "sfxClick", volume: customARView.sfxVolume)
                    customARView.resetGame()
                    showGameEnd = false
                }) {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 24)
                        .overlay {
                            ZStack {
                                VStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white.opacity(0.2))
                                    RoundedRectangle(cornerRadius: 24)
                                        .opacity(0)
                                }
                                .padding(8)
                                
                                Text("Play Again")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                }
            }
            .padding(24)
        }
        .padding(40)
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
        .onAppear {
            let soundEffect = isCorrect ? "sfxGuessCorrect" : "sfxGuessIncorrect"
            AudioManager.shared.playSFX(filename: soundEffect, volume: customARView.sfxVolume)
        }
    }
}

#Preview {
    GameEndView(showMainMenu: .constant(true), showGameEnd: .constant(true), isCorrect: .constant(true), customARView: CustomARView(frame: .zero))
}
