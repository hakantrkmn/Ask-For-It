//
//  AuthService.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthService
{
    public static func registerUser(with userRequest : RegisterUserRequest ) async throws
    {
        try await Auth.auth().createUser(withEmail: userRequest.email, password: userRequest.password)
    }
    
    public static func loginUser(with loginRequest : LoginUserRequest) async throws
    {
        try await Auth.auth().signIn(withEmail: loginRequest.email, password: loginRequest.password)
    }
    
    public static func logoutUser() throws
    {
        try  Auth.auth().signOut()
        
    }
}
