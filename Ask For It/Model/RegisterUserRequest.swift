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
}


enum Section
{
    case first
}

struct Option : Hashable
{
    var id = UUID()
    var title : String
}
