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
    var createdUserID : String
    var title : String
    var optionID : [String]
    var answeredUserID : [String]
    var createdAt : TimeInterval
    
    init(userId: String, title: String, optionIDs: [String], answeredUserIDs: [String], createdAt: TimeInterval) {
        self.createdUserID = userId
        self.title = title
        self.optionID = optionIDs
        self.answeredUserID = answeredUserIDs
        self.createdAt = createdAt
    }
}

class Question : Codable
{
    var createdUserID : String
    var title : String
    var option : [Option]
    var answeredUserID : [String]
    var createdAt : TimeInterval
    var createdUserInfo : User?
    
    
    
    init(userId: String, title: String, options: [Option], answeredUserIDs: [String], createdAt: TimeInterval, userInfo: User? = nil) {
        self.createdUserID = userId
        self.title = title
        self.option = options
        self.answeredUserID = answeredUserIDs
        self.createdAt = createdAt
        self.createdUserInfo = userInfo
    }
}
