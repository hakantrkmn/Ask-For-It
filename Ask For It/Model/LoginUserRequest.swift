//
//  LoginUserRequest.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation

struct LoginUserRequest
{
    let email : String
    let password : String
}


struct UserInfo : Codable
{
    let username : String
    let email : String
}

struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

