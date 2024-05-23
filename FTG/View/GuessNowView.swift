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
            // Top Container
            ZStack {
                Text("Guess Now")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
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
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 16)
                        .padding(.top, 16)
                    Divider()
                        .frame(minHeight: 4)
                        .background(Color.black)
                        .padding(.leading, 32)
                        .padding(.trailing, -8)
                    ScrollView {
                        VStack {
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
                                            .frame(width: 80, height: 80)
                                            .padding()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.description)
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.8))
                                    }
                                    Spacer()
                                }
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.leading, 32)
                    }
                }
                
                Divider()
                    .frame(minWidth: 4)
                    .background(Color.black)
                
                VStack(alignment: .center) {
                    Text("Select Evidence")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 16)
                        .padding(.top, 16)
                    Divider()
                        .frame(minHeight: 4)
                        .background(Color.black)
                        .padding(.horizontal, -8)
                    ScrollView {
                        ForEach(allEvidence, id: \.self) { evidence in
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 48)
                                .foregroundColor(Color.white.opacity(0.2))
                                .overlay{
                                    EvidenceRow(evidence: evidence, isSelected: selectedEvidence.contains(evidence)) {
                                        toggleEvidenceSelection(evidence)
                                    }
                                    .font(.body)
                                    .padding()
                                    .foregroundColor(.black)
                                }
                        }
                    }
                }
                
                Divider()
                    .frame(minWidth: 2)
                    .background(Color.black)
                
                VStack(alignment: .center) {
                    Text("Possible Answers")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 16)
                        .padding(.top, 16)
                    Divider()
                        .frame(minHeight: 4)
                        .background(Color.black)
                        .padding(.trailing, 32)
                        .padding(.leading, -8)
                    ScrollView {
                        ForEach(possibleAnswers, id: \.self) { answer in
                            Button(action: {
                                selectedAnswer = answer
                            }) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 48)
                                    .foregroundColor(selectedAnswer == answer ? Color.green.opacity(0.4) : Color.white.opacity(0.2))
                                    .overlay{
                                        Text(answer)
                                            .font(.body)
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                            }
                        }
                        .padding(.trailing, 32)
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height * 2 / 3)
                }
            }
            .padding()
            
            Button(action: submitGuess) {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 24)
                    .overlay{
                        ZStack {
                            VStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white.opacity(0.2))
                                RoundedRectangle(cornerRadius: 24)
                                    .opacity(0)
                            }
                            .padding(8)
                            
                            Text("Submit Guess")
                                .font(.title2)
                                .padding()
                                .foregroundColor(.white)
                        }
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
            }
            .padding(.bottom, 24)
            .padding()
        }
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
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
                    ZStack {
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.white)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.6))
                    }
                } else {
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .cornerRadius(8)
        }
    }
}

#Preview {
    GuessNowView(arView: CustomARView(frame: .zero), showGuessNow: .constant(true), showGameEnd: .constant(false), isCorrect: .constant(true))
}
