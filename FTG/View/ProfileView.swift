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
//                    .padding(.top)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showProfile.toggle()
                        }
                        AudioManager.shared.playSFX(filename: "sfxClick", volume: sfxVolume)
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
            ZStack{
                let barSize: CGFloat = 40
                let value = Float(customARView.exp) / Float((customARView.level + 4) * 20)
                
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let progressBarWidth = CGFloat(value) * width

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundColor(Color.gray.opacity(0.2))
                            .frame(height: barSize)
                        
                        RoundedRectangle(cornerRadius: 24)
                            .frame(width: progressBarWidth, height: barSize)
                            .foregroundColor(Color(hex:"#32C1FE"))
                            .clipShape(.rect(bottomTrailingRadius: 24, topTrailingRadius: 24))
                        
                        ZStack{
                            VStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .foregroundColor(.white.opacity(0.2))
                                RoundedRectangle(cornerRadius: 24)
                                    .opacity(0)
                            }
                            .padding(8)
                            .padding(.top, 4)
                            
                            Text("EXP: \(customARView.exp) / \((customARView.level + 4) * 20)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                        }
                    }
                    .frame(height: barSize)
                }
                .frame(width: UIScreen.main.bounds.width/3, height: barSize)
                
                
            }
        }
        .padding()
        .padding(.vertical)
        .padding(.bottom, 32)
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}

#Preview {
    ProfileView(customARView: CustomARView(frame: .zero), showProfile: .constant(true), sfxVolume: .constant(0))
}
