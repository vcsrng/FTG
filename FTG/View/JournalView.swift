//
//  JournalView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct JournalView: View {
    var answerList: [String: [String]]
    
    @Binding var showJournal: Bool
    @Binding var sfxVolume: Float
    
    var body: some View {
        VStack {
            ZStack {
                Text("Journal")
                    .font(.largeTitle)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showJournal.toggle()
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
                ForEach(Array(answerList.keys), id: \.self) { answer in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(answer)
                            .font(.headline)
                        ForEach(answerList[answer]!, id: \.self) { evidence in
                            Text("- \(evidence)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding([.leading, .trailing, .top])
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
