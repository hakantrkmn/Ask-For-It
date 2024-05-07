//
//  Question.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 26.04.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class QuestionQuery : Codable
{
    var userId : String
    var title : String
    var optionIDs : [String]
    var answeredUserIDs : [String]
    var createdAt : TimeInterval
    
    init(userId: String, title: String, optionIDs: [String], answeredUserIDs: [String], createdAt: TimeInterval) {
        self.userId = userId
        self.title = title
        self.optionIDs = optionIDs
        self.answeredUserIDs = answeredUserIDs
        self.createdAt = createdAt
    }
}

class Question : Codable
{
    var userId : String
    var title : String
    var options : [Option]
    var answeredUserIDs : [String]
    var createdAt : TimeInterval
    var userInfo : User?
    
    init(userId: String, title: String, options: [Option], answeredUserIDs: [String], createdAt: TimeInterval, userInfo: User? = nil) {
        self.userId = userId
        self.title = title
        self.options = options
        self.answeredUserIDs = answeredUserIDs
        self.createdAt = createdAt
        self.userInfo = userInfo
    }
}
