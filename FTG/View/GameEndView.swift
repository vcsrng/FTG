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
    @ObservedObject var arView: CustomARView

    var body: some View {
        VStack {
            Text(isCorrect ? "Congratulations! You guessed correctly!" : "Sorry, your guess was incorrect.")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                showMainMenu = true
                showGameEnd = false
            }) {
                Text("Back to Main Menu")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                arView.resetGame()
                showGameEnd = false
                // Optionally set showGuessNow to true if you want to directly start guessing again
            }) {
                Text("Play Again")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                showGameEnd = false
            }) {
                Text("Close")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
