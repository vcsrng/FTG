//
//  GuessNowView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct GuessNowView: View {
    @Binding var selectedGhostType: String
    @Binding var showGuessNow: Bool

    let ghostTypes = ["Poltergeist", "Phantom", "Banshee", "Jinn", "Mare"]

    var body: some View {
        VStack {
            Text("Guess the Ghost")
                .font(.largeTitle)
                .padding()

            List(ghostTypes, id: \.self) { ghostType in
                Button(action: {
                    selectedGhostType = ghostType
                }) {
                    HStack {
                        Text(ghostType)
                        Spacer()
                        if selectedGhostType == ghostType {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .frame(width: 400, height: 600)
            .cornerRadius(12)
            .padding()

            Button("Submit Guess") {
                showGuessNow = false
                // Add logic to handle the guess submission
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(24)
        .padding(80)
    }
}

struct GuessNowView_Previews: PreviewProvider {
    static var previews: some View {
        GuessNowView(selectedGhostType: .constant("Poltergeist"), showGuessNow: .constant(true))
    }
}
