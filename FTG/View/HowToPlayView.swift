//
//  HowToPlayView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        VStack {
            Text("How to Play")
                .font(.largeTitle)
                .padding()
            
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
            .padding()
        }
    }
}
