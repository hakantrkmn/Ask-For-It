//
//  RegisterUserRequest.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation

struct RegisterUserRequest
{
    var username : String
    var email : String
    var password :String
    var answeredQuestionID : [String]?
    var createdQuestionID : [String]?
    var followedUserID : [String]
    var followingUserID : [String]
}

