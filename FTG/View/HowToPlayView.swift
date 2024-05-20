//
//  HowToPlayView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var showHowToPlay: Bool
    @Binding var sfxVolume: Float
    
    var body: some View {
        VStack {
            ZStack{
                Text("How to Play")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showHowToPlay.toggle()
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("1. Explore the area and collect items.")
                    Text("2. Select evidence from the collected items and possible answers.")
                    Text("3. Make your guess based on the selected evidence.")
                    Text("4. Submit your guess and see if you're correct!")
                }
                .padding()
                .font(.title2)
            }
//            .padding()
        }
    }
}

#Preview {
    HowToPlayView(showHowToPlay: .constant(true), sfxVolume: .constant(0.5))
}
