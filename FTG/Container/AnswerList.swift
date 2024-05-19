//
//  AnswerList.swift
//  FTG
//
//  Created by Vincent Saranang on 19/05/24.
//

import Foundation

struct AnswerList {
    static let itemDescriptions: [String] = ["Evidence 1", "Evidence 2", "Evidence 3", "Evidence 4", "Evidence 5"]
    
    static let answerList: [String: [String]] = [
        "Answer 1": ["Evidence 1", "Evidence 2"],
        "Answer 2": ["Evidence 2", "Evidence 3"],
        "Answer 3": ["Evidence 1", "Evidence 3", "Evidence 4"],
        "Answer 4": ["Evidence 4", "Evidence 5"]
    ]
}
