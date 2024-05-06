//
//  Option.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 26.04.2024.
//

import Foundation


class Option : Codable
{
    var title : String
    var questionId : String
    var userIDs : [String]
    
    init(title: String, questionId: String, userIDs: [String]) {
        self.title = title
        self.questionId = questionId
        self.userIDs = userIDs
    }
}


