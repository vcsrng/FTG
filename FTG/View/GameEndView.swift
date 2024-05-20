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
            VStack {
                Text(isCorrect ? "Congratulations!" : "Unfortunately")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(isCorrect ? "You guessed correctly!" : "Your guess was incorrect.")
                    .font(.title)
            }
            .padding()
            .padding(.bottom, 56)
           
            
            HStack {
                Button(action: {
                    showMainMenu = true
                    showGameEnd = false
                }) {
                    Text("Main Menu")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
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
            }
            .padding(.horizontal, 24)
            
//            Button(action: {
//                showGameEnd = false
//            }) {
//                Text("Close")
//                    .font(.title)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
        }
        .padding(40)
    }
}

#Preview {
    GameEndView(showMainMenu: .constant(true), showGameEnd: .constant(true), isCorrect: .constant(true), arView: CustomARView(frame: .zero))
}
