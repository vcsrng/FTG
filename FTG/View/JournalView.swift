//
//  JournalView.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import SwiftUI

struct JournalView: View {
    let collectedItems: [String]
    @Binding var showJournal: Bool

    var body: some View {
        VStack {
            Text("Journal")
                .font(.largeTitle)
                .padding()

            List(collectedItems, id: \.self) { item in
                Text(item)
            }
            .frame(width: 400, height: 600)
            .cornerRadius(12)
            .padding()

            Button("Close") {
                showJournal = false
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(24)
        .padding(80)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(collectedItems: ["Item 1", "Item 2"], showJournal: .constant(true))
    }
}
