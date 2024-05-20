//
//  GuessNowView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct GuessNowView: View {
    @ObservedObject var arView: CustomARView
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedEvidence: Set<String> = []
    @State private var possibleAnswers: [String] = []
    @State private var selectedAnswer: String? = nil
    @Binding var showGuessNow: Bool
    @Binding var showGameEnd: Bool
    @Binding var isCorrect: Bool
    
    private var allEvidence: [String] {
        Array(Set(arView.answerList.values.flatMap { $0 })).sorted()
    }
    
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
                        AudioManager.shared.playSFX(filename: "ButtonClick", volume: arView.sfxVolume)
                    }) {
                        Image(systemName: "x.square.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                            .padding()
                    }
                    .padding()
                }
            }
            
            HStack {
                VStack {
                    Text("Collected Items")
                        .font(.headline)
                        .padding()
                    ScrollView {
                        ForEach(arView.inventory.items, id: \.id) { item in
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
                                    Text(item.description)
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
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height * 2 / 3)
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .center) {
                    Text("Select Evidence")
                        .font(.headline)
                        .padding()
                    ScrollView {
                        ForEach(allEvidence, id: \.self) { evidence in
                            EvidenceRow(evidence: evidence, isSelected: selectedEvidence.contains(evidence)) {
                                toggleEvidenceSelection(evidence)
                            }
                        }
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height * 2 / 3)
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .center) {
                    Text("Possible Answers")
                        .font(.headline)
                        .padding()
                    ScrollView {
                        ForEach(possibleAnswers, id: \.self) { answer in
                            Button(action: {
                                selectedAnswer = answer
                            }) {
                                Text(answer)
                                    .font(.body)
                                    .padding()
                                    .background(selectedAnswer == answer ? Color.green : Color.gray)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height * 2 / 3)
                }
                .padding()
            }
            .padding()
            
            Button(action: submitGuess) {
                Text("Submit Guess")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: updatePossibleAnswers)
    }
    
    private func toggleEvidenceSelection(_ evidence: String) {
        if selectedEvidence.contains(evidence) {
            selectedEvidence.remove(evidence)
        } else {
            selectedEvidence.insert(evidence)
        }
        updatePossibleAnswers()
    }
    
    private func updatePossibleAnswers() {
        possibleAnswers = arView.answerList.filter { answer, evidences in
            selectedEvidence.isSubset(of: evidences)
        }.map { $0.key }.sorted()
        
        if possibleAnswers.count == 1 {
            selectedAnswer = possibleAnswers.first
        } else {
            selectedAnswer = nil
        }
    }
    
    private func submitGuess() {
        guard let selectedAnswer = selectedAnswer else { return }
        arView.handleGuess(guess: selectedAnswer)
        
        isCorrect = arView.isGuessCorrect
        showGuessNow = false
        showGameEnd = true
    }
}

struct EvidenceRow: View {
    let evidence: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(evidence)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

#Preview {
    GuessNowView(arView: CustomARView(frame: .zero), showGuessNow: .constant(true), showGameEnd: .constant(false), isCorrect: .constant(true))
}
