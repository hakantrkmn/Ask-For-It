//
//  UserInfo.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 6.05.2024.
//

import Foundation

extension Notification.Name {
    static let userInfoChanged = Notification.Name("userInfoChanged")
}

class UserInfo
{
    static let shared = UserInfo()
    
    var user = User(id: "", email: "", username: "", answeredQuestionID: [], createdQuestionID: [], followedUserID: [] , followingUserID: []){
        didSet {
            NotificationCenter.default.post(name: .userInfoChanged, object: nil)
                }
    }
    
  
    
}
