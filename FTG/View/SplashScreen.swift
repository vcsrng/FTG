//
//  SplashScreen.swift
//  FTG
//
//  Created by Vincent Saranang on 21/05/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var splashTime: Bool = false

    var body: some View {
        ZStack {
            if splashTime {
                Image("FTG-justtext")
                    .resizable()
                    .frame(width: 275, height: 270)
                    .scaledToFill()
                    .transition(anchorTransition())
            } else {
                Image("FTG-text")
                    .resizable()
                    .frame(width: 480, height: 270)
                    .scaledToFill()
                    .transition(anchorTransition())
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    splashTime = true
                }
            }
        }
    }

    // Custom transition modifier
    private func anchorTransition() -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.scale(scale: 0.0, anchor: .center).combined(with: .opacity),
            removal: AnyTransition.scale(scale: 0.0, anchor: .center).combined(with: .opacity)
        )
    }
}

#Preview {
    SplashScreen()
}
