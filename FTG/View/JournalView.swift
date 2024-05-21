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
    @State private var selectedAnswer: String? = nil
    
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
                    .fontWeight(.bold)
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
                        .font(.title)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(40)
            
            ScrollView {
                switch selectedSegment {
                case .overview:
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 16) {
                            Rectangle()
                                .clipShape(.rect(bottomTrailingRadius: 60, topTrailingRadius: 60))
                                .foregroundColor(Color.yellow.opacity(0.1))
                                .frame(width: 240, height: 80)
                                .overlay {
                                    Text("How to Play")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                .padding(.bottom, 16)
//                            RoundedRectangle(cornerRadius: 24)
//                                .foregroundColor(Color.yellow.opacity(0.1))
//                                .frame(width: 240, height: 80)
//                                .overlay {
//                                    Text("How to Play")
//                                        .font(.title)
//                                        .fontWeight(.bold)
//                                        .padding()
//                                }
//                                .padding(.bottom, 16)
                            
                            Text("1. Explore the area and collect items.")
                                .font(.title2)
                            Text("2. Select evidence from the collected items and possible answers.")
                                .font(.title2)
                            Text("3. Make your guess based on the selected evidence.")
                                .font(.title2)
                            Text("4. Submit your guess and see if you're correct!")
                                .font(.title2)
                        }
                        .padding(40)
                        .cornerRadius(8)
                        Spacer()
                    }
                    
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
                        .padding(.horizontal, 8)
                    }
                    
                case .answers:
                    GeometryReader { geometry in
                        HStack {
                            // Answer list
                            VStack(alignment: .center) {
                                Text("Answer List")
                                    .font(.title2)
                                    .padding(.bottom, 24)
                                Spacer()
                                ScrollView {
                                    ForEach(Array(arView.answerList.keys), id: \.self) { answer in
                                        Button(action: {
                                            selectedAnswer = answer
                                        }) {
                                            Ellipse()
                                                .strokeBorder(style: StrokeStyle())
                                                .foregroundColor(selectedAnswer == answer ? Color.black : Color.clear)
                                                .frame(width: 160, height: 56)
                                                .overlay {
                                                    Text(answer)
                                                        .font(.headline)
                                                }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .cornerRadius(8)
                            .frame(width: geometry.size.width / 2)
                            
                            Divider()
                            // Evidence list
                            VStack(alignment: .center) {
                                Text("Evidence List")
                                    .font(.title2)
                                    .padding(.bottom, 24)
                                Spacer()
                                if let selectedAnswer = selectedAnswer {
                                    ScrollView {
                                        ForEach(arView.answerList[selectedAnswer] ?? [], id: \.self) { evidence in
                                            RoundedRectangle(cornerRadius: 24)
                                                .foregroundColor(.gray.opacity(0.1))
                                                .frame(width: geometry.size.width / 2 - 120, height: 50)
                                                .overlay {
                                                    Text(evidence)
                                                        .font(.subheadline)
                                                        .padding()
                                                }
                                                .padding(.vertical, 4)
                                        }
                                    }
                                } else {
                                    Text("Select an answer to see the evidence.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(width: geometry.size.width / 2)
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    JournalView(arView: CustomARView(frame: .zero), showJournal: .constant(true))
}
