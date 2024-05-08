//
//  UserInfo.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 6.05.2024.
//

import Foundation


class UserInfo
{
    static let shared = UserInfo()
    
    var user = User(id: "" ,email: "", username: "")
    
    init() {
        
    }
    
}
