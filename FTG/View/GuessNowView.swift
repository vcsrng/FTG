//
//  GuessNowView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct GuessNowView: View {
    @ObservedObject var inventory: Inventory
    @Binding var showGuessNow: Bool
    @Binding var sfxVolume: Float

    @State private var selectedEvidence: Set<String> = []
    
    var itemDescriptions: [String]
    var answerKey: String
    var answerList: [String: [String]] // Dictionary to hold answers and their corresponding evidence

    var body: some View {
        VStack {
            ZStack {
                Text("Guess Now")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showGuessNow.toggle()
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
                Text("Collected Items")
                    .font(.title2)
                    .padding(.top)

                ForEach(inventory.items, id: \.id) { item in
                    HStack {
                        if let thumbnail = item.thumbnail {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .frame(width: 80, height: 80)
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
                    .padding([.leading, .trailing, .top])
                }

                Text("Select Evidence")
                    .font(.title2)
                    .padding(.top)

                ForEach(itemDescriptions, id: \.self) { description in
                    Button(action: {
                        if selectedEvidence.contains(description) {
                            selectedEvidence.remove(description)
                        } else {
                            selectedEvidence.insert(description)
                        }
                        AudioManager.shared.playSFX(filename: "ButtonClick", volume: sfxVolume)
                    }) {
                        HStack {
                            Text(description)
                                .padding()
                            Spacer()
                            if selectedEvidence.contains(description) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .padding()
                            }
                        }
                        .background(selectedEvidence.contains(description) ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 2)
                    }
                }
                
                Text("Possible Answers")
                    .font(.title2)
                    .padding(.top)
                
                ForEach(filteredAnswers(), id: \.self) { answer in
                    HStack {
                        Text(answer)
                            .padding()
                        Spacer()
                    }
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                // Add the logic to handle the final guess here
                withAnimation {
                    showGuessNow.toggle()
                }
                AudioManager.shared.playSFX(filename: "ButtonClick", volume: sfxVolume)
            }) {
                Text("Submit Guess")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
    }
    
    private func filteredAnswers() -> [String] {
        return answerList.filter { answer, evidences in
            Set(evidences).isSubset(of: selectedEvidence)
        }.map { $0.key }
    }
}

struct GuessNowView_Previews: PreviewProvider {
    static var previews: some View {
        GuessNowView(inventory: Inventory(), showGuessNow: .constant(true), sfxVolume: .constant(0.5), itemDescriptions: ["Evidence 1", "Evidence 2", "Evidence 3"], answerKey: "Coach", answerList: ["Answer 1": ["Evidence 1", "Evidence 2"], "Answer 2": ["Evidence 2", "Evidence 3"]])
    }
}
