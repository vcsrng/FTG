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
    @State private var selectedPage: Int = 0
    @State private var selectedAnswer: String? = nil

    let pages: [JournalSegment] = [.overview, .evidence, .answers]

    enum JournalSegment: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case evidence = "Evidence"
        case answers = "Answers"

        var id: String { self.rawValue }
    }

    var body: some View {
        VStack {
            // Top container
            ZStack {
                Text("Game Guide")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
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

            // Custom Bookmark Picker
            HStack {
                ForEach(pages.indices, id: \.self) { index in
                    BookmarkTab(isSelected: selectedPage == index, text: pages[index].rawValue)
                        .onTapGesture {
                            withAnimation {
                                selectedPage = index
                            }
                        }
                }
            }
            .padding(.horizontal, 44)

            // Page View
            TabView(selection: $selectedPage) {
                ForEach(pages.indices, id: \.self) { index in
                    pageView(for: pages[index])
                        .tag(index)
                        .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide built-in tabview indicator
            .background(Color.white.opacity(0.2))
            .clipShape(.rect(bottomLeadingRadius: 24, bottomTrailingRadius: 24))
            .padding(.horizontal, 40)

            // Custom Page Control
            HStack {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(selectedPage == index ? .black : .gray)
                        .onTapGesture {
                            withAnimation {
                                selectedPage = index
                            }
                        }
                }
            }
            .padding()
        }
        .scaleEffect(0.9)
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }

    @ViewBuilder
    private func pageView(for segment: JournalSegment) -> some View {
        switch segment {
        case .overview:
            overviewView()
        case .evidence:
            evidenceView()
        case .answers:
            answersView()
        }
    }

    private func overviewView() -> some View {
        VStack {
            VStack(alignment:.leading){
                Text("How to Play")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical, 16)
                    .padding(.top, 16)
                Divider()
                    .frame(minHeight: 4)
                    .background(Color.black)
                ForEach(1...4, id: \.self) { index in
                    HStack {
                        Circle()
                            .frame(width: 32)
                            .foregroundColor(Color.black)
                            .overlay {
                                Text("\(index)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                }
                        Text(overviewText(for: index))
                            .font(.title2)
                            .padding(.leading, 8)
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 32)
            Spacer()
        }
    }

    private func evidenceView() -> some View {
        VStack(alignment: .leading){
            Text("Found Item List")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 16)
                .padding(.top, 16)
            Divider()
                .frame(minHeight: 4)
                .background(Color.black)
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
                                    .fontWeight(.bold)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.8))
                            }
                            Spacer()
                        }
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.top)
                    }
                }
            }
        }.padding(.horizontal, 32)
    }

    private func answersView() -> some View {
        GeometryReader { geometry in
            HStack{
                //Kiri
                VStack{
                    Text("Answer List")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 16)
                        .padding(.top, 16)
                    Divider()
                        .frame(minHeight: 4)
                        .background(Color.black)
                        .padding(.leading, 32)
                        .padding(.trailing, -8)
                    ScrollView(showsIndicators: false) {
                        ForEach(Array(arView.answerList.keys), id: \.self) { answer in
                            Button(action: {
                                selectedAnswer = answer
                            }) {
                                Image("EllipseMarker")
                                    .resizable()
                                    .frame(width: 160, height: 80)
                                    .opacity(selectedAnswer == answer ? 1 : 0)
                                    .overlay{
                                        Text(answer)
                                            .font(.headline)
                                            .foregroundColor(Color.black)
                                            .padding(.top)
                                    }
//                                Ellipse()
//                                    .strokeBorder()
//                                    .foregroundColor(selectedAnswer == answer ? Color.black : Color.clear)
//                                    .frame(width: 160, height: 56)
//                                    .overlay {
//                                        Text(answer)
//                                            .font(.headline)
//                                            .foregroundColor(Color.black)
//                                    }
                            }
                            .padding(.top)
                        }
                    }
                }
                
                // Batas
                Spacer()
                Divider()
                    .frame(minWidth: 4)
                    .background(Color.black)
                Spacer()
                
                //Kanan
                VStack{
                    Text("Evidence List")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 16)
                        .padding(.top, 16)
                    Divider()
                        .frame(minHeight: 4)
                        .background(Color.black)
                        .padding(.trailing, 32)
                        .padding(.leading, -8)
                    Spacer()
                    if let selectedAnswer = selectedAnswer {
                        ScrollView(showsIndicators: false) {
                            ForEach(arView.answerList[selectedAnswer] ?? [], id: \.self) { evidence in
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder()
                                    .foregroundColor(.black)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: geometry.size.width / 3 - 120, height: 50)
                                    .overlay {
                                        Text(evidence)
                                            .font(.headline)
                                            .padding()
                                    }
                                    .padding(.top)
                            }
                        }
                    } else {
                        VStack(alignment: .center){
                            Text("Select an answer to see the evidence.")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func overviewText(for index: Int) -> String {
        switch index {
        case 1:
            return "Explore the area and collect items."
        case 2:
            return "Select evidence from the collected items and possible answers."
        case 3:
            return "Make your guess based on the selected evidence."
        case 4:
            return "Submit your guess and see if you're correct!"
        default:
            return ""
        }
    }
}

// Custom BookmarkTab View
struct BookmarkTab: View {
    var isSelected: Bool
    var text: String

    var body: some View {
        VStack(alignment: .leading){
            Rectangle()
                .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
                .foregroundColor(isSelected ? .white.opacity(0.2) : .gray.opacity(0.2))
                .frame(width: (UIScreen.main.bounds.width-80)/3, height: 80)
                .overlay {
                    Text(text)
                        .font(.title)
                        .fontWeight(.bold)
                    }
                .padding(.horizontal, -4)
                .padding(.bottom, -8)
            Rectangle()
                .fill(isSelected ? Color.white.opacity(0.2) : Color.black)
                .frame(width: (UIScreen.main.bounds.width-80)/3,height: 4)
                .padding(.horizontal, -4)
                .padding(.bottom, -8)
        }
        .padding(.bottom,-4)
    }
}

#Preview {
    JournalView(arView: CustomARView(frame: .zero), showJournal: .constant(true))
}
