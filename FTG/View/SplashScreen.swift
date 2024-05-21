//
//  SplashScreen.swift
//  FTG
//
//  Created by Vincent Saranang on 21/05/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("FTG-text")
                .resizable()
                .frame(width: 480, height: 270)
                .scaledToFill()
            Image("FTG-justtext")
                .resizable()
                .frame(width: 275, height: 270)
                .scaledToFill()
        }
    }
}

#Preview {
    SplashScreen()
}
