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
    
    var body: some View {
        VStack {
            Text("Guess Now").font(.largeTitle)
            
            // Evidence selection list
            List(arView.inventory.items, id: \.name) { item in
                Button(action: {
                    toggleEvidenceSelection(item.name)
                }) {
                    HStack {
                        Text(item.name)
                        if selectedEvidence.contains(item.name) {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            // Possible answers based on selected evidence
            List(possibleAnswers, id: \.self) { answer in
                Text(answer)
            }
            
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
        }.map { $0.key }
    }
    
    private func submitGuess() {
        // Implement guess submission logic
        presentationMode.wrappedValue.dismiss()
    }
}
