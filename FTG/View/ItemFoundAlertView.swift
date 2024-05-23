//
//  ItemFoundAlertView.swift
//  FTG
//
//  Created by Vincent Saranang on 23/05/24.
//

import SwiftUI

struct ItemFoundAlertView: View {
    var itemName: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(.white)
                    .overlay(
                        VStack {
                            Text("Item Found")
                                .font(Font.custom("Koulen-Regular", size: 64))
                                .padding(.bottom, -32)
                            HStack{
                                Text("You found: ")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(.trailing,-8)
                                Text(itemName)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .padding()
                        .padding(.vertical, 16)
                        .padding(.bottom, 16)
                        .background(
                            Image("BrownTexture2")
                                .resizable()
                                .frame(width: 1384, height: 1384)
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 4)
                Spacer()
            }
        }
    }
}

#Preview {
    ItemFoundAlertView(itemName: "Boba")
}
