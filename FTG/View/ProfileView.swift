//
//  ProfileView.swift
//  FTG
//
//  Created by Vincent Saranang on 24/05/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var customARView: CustomARView
    @Binding var showProfile: Bool
    @Binding var sfxVolume: Float
    
    var body: some View {
        VStack {
            ZStack {
                Text("Profile")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showProfile.toggle()
                        }
                        AudioManager.shared.playSFX(filename: "ButtonClick", volume: sfxVolume)
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .overlay{
                                ZStack{
                                    VStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white.opacity(0.2))
                                        RoundedRectangle(cornerRadius: 16)
                                            .opacity(0)
                                    }
                                    .padding(4)
                                    Image("CloseIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .shadow(radius: 4)
                                    
                                }
                            }
                            .padding(.trailing, 24)
                    }
                    .padding()
                }
            }
            Text("Level \(customARView.level)")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Text("EXP: \(customARView.exp) / \((customARView.level + 4) * 20)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
        }
        .padding()
        .padding(.vertical, 16)
        .padding(.bottom, 32)
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}

