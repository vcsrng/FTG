//
//  JournalView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct JournalView: View {
    @ObservedObject var inventory: Inventory
    let answerKey: String
    @Binding var showJournal: Bool
    @Binding var sfxVolume: Float

    var body: some View {
        VStack {
            ZStack {
                Text("Journal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
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
                VStack(alignment: .leading, spacing: 16) {
                    // Game Overview
                    Text("Game Overview")
                        .font(.headline)
                    Text("In this game, you need to find and collect items scattered in the AR environment. Use the clues from the items to determine the answer key.")
                        .padding(.bottom)

                    // Item Evidence List
                    Text("Item Evidence List")
                        .font(.headline)
                    ForEach(inventory.items, id: \.id) { item in
                        HStack {
                            if let thumbnail = item.thumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding()
                            } else {
                                Image(systemName: "cube.box.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding()
                            }
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.modelURL.absoluteString)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    // Answer Key Section
                    Text("Answer Key")
                        .font(.headline)
                        .padding(.top)
                    Text("Based on the collected items, the answer key is: \(answerKey)")
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.top, 40)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(inventory: Inventory(), answerKey: "Sample Answer Key", showJournal: .constant(true), sfxVolume: .constant(1.0))
    }
}
