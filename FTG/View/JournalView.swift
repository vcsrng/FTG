//
//  JournalView.swift
//  FTG
//
//  Created by Vincent Saranang on 18/05/24.
//

import SwiftUI

struct JournalView: View {
    @ObservedObject var arView: CustomARView
    @Binding var showJournal: Bool
    @State private var selectedSegment: JournalSegment = .overview
    
    enum JournalSegment: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case evidence = "Evidence"
        case answers = "Answers"
        
        var id: String { self.rawValue }
    }
    
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
            
            Picker("Select Segment", selection: $selectedSegment) {
                ForEach(JournalSegment.allCases) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                switch selectedSegment {
                case .overview:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to Play")
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        Text("1. Explore the area and collect items.")
                        Text("2. Select evidence from the collected items and possible answers.")
                        Text("3. Make your guess based on the selected evidence.")
                        Text("4. Submit your guess and see if you're correct!")
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                case .evidence:
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
                    
                case .answers:
                    ForEach(Array(arView.answerList.keys), id: \.self) { answer in
                        VStack(alignment: .center, spacing: 8) {
                            Text(answer)
                                .font(.headline)
                                .padding(.bottom, 8)
                            
                            ForEach(arView.answerList[answer] ?? [], id: \.self) { evidence in
                                Text("- \(evidence)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
        }
    }
}
