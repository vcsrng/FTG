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
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
                
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
                Spacer(minLength: 40)
                VStack(alignment: .leading, spacing: 16) {
                    HStack{
                        Circle()
                            .frame(width: 32)
                            .foregroundColor(Color.black)
                            .overlay{
                                Text("1")
                                    .font(.title2)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                        Text("Explore the area and collect items.")
                            .font(.title2)
                            .padding(.leading, 8)
                    }
                    HStack{
                        Circle()
                            .frame(width: 32)
                            .foregroundColor(Color.black)
                            .overlay{
                                Text("2")
                                    .font(.title2)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                        Text("Select evidence from the collected items and possible answers.")
                            .font(.title2)
                            .padding(.leading, 8)
                    }
                    HStack{
                        Circle()
                            .frame(width: 32)
                            .foregroundColor(Color.black)
                            .overlay{
                                Text("3")
                                    .font(.title2)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                        Text("Make your guess based on the selected evidence.")
                            .font(.title2)
                            .padding(.leading, 8)
                    }
                    HStack{
                        Circle()
                            .frame(width: 32)
                            .foregroundColor(Color.black)
                            .overlay{
                                Text("4")
                                    .font(.title2)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                        Text("Submit your guess and see if you're correct!")
                            .font(.title2)
                            .padding(.leading, 8)
                    }
//                    Text("1. Explore the area and collect items.")
//                        .font(.title2)
//                    Text("2. Select evidence from the collected items and possible answers.")
//                        .font(.title2)
//                    Text("3. Make your guess based on the selected evidence.")
//                        .font(.title2)
//                    Text("4. Submit your guess and see if you're correct!")
//                        .font(.title2)
                }
//                .padding(.top, 40)
//                .padding(.horizontal, 32)
                .cornerRadius(8)
                
            }
            .padding()
//            .padding(.vertical, 40)
        }
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}

#Preview {
    HowToPlayView(showHowToPlay: .constant(true), sfxVolume: .constant(0))
}
