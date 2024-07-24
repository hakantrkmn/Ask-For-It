//
//  User.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 6.05.2024.
//

import Foundation


struct User : Codable
{
    let id : String
    let email : String
    let username : String
    var answeredQuestionID : [String]?
    var createdQuestionID : [String]?
    var followedUserID : [String]
    var followingUserID : [String]

}
