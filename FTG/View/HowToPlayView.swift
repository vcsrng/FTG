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
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
                VStack(alignment: .leading, spacing: 16) {
                    Text("1. Explore the area and collect items.")
                        .font(.title2)
                    Text("2. Select evidence from the collected items and possible answers.")
                        .font(.title2)
                    Text("3. Make your guess based on the selected evidence.")
                        .font(.title2)
                    Text("4. Submit your guess and see if you're correct!")
                        .font(.title2)
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
