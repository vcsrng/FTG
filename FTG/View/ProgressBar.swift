//
//  ProgressBar.swift
//  FTG
//
//  Created by Vincent Saranang on 24/05/24.
//

import SwiftUI

struct ProgressBar: View {
    @State private var barSize: CGFloat = 56
    var value: Float

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let progressBarWidth = CGFloat(value) * width

                ZStack(alignment: .leading) {
                    Rectangle()
                        .clipShape(.rect(bottomTrailingRadius: 24, topTrailingRadius: 24))
                        .foregroundColor(Color.gray.opacity(0.2))
                        .frame(height: barSize)
                    
                    Rectangle()
                        .clipShape(.rect(bottomTrailingRadius: 24, topTrailingRadius: 24))
                        .frame(width: progressBarWidth, height: barSize)
                        .foregroundColor(Color(hex:"#32C1FE"))
                        .clipShape(.rect(bottomTrailingRadius: 24, topTrailingRadius: 24))
                    
                    ZStack{
                        VStack {
                            Rectangle()
                                .clipShape(.rect(bottomTrailingRadius: 24, topTrailingRadius: 24))
                                .foregroundColor(.white.opacity(0.2))
                            RoundedRectangle(cornerRadius: 24)
                                .opacity(0)
                        }
                        .padding(8)
                    }
                }
                .frame(height: barSize)
            }
            .frame(width: UIScreen.main.bounds.width/5, height: barSize)
        }
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

#Preview {
    ProgressBar(value: 0.5)
}
