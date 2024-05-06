//
//  Question.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 26.04.2024.
//

import Foundation

class QuestionQuery : Codable
{
    var userId : String
    var title : String
    var optionIDs : [String]
    var answeredUserIDs : [String]
    init(userId: String, title: String, optionIDs: [String], answeredUserIDs: [String]) {
        self.userId = userId
        self.title = title
        self.optionIDs = optionIDs
        self.answeredUserIDs = answeredUserIDs
    }
}

class Question : Codable
{
    @DocumentID var id : String?
    var userId : String
    var title : String
    var options : [Option]
    var answeredUserIDs : [String]

    init(userId: String, title: String, options: [Option], answeredUserIDs: [String]) {
        self.userId = userId
        self.title = title
        self.options = options
        self.answeredUserIDs = answeredUserIDs
    }
}
