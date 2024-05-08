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
        var result = try await Auth.auth().createUser(withEmail: userRequest.email, password: userRequest.password)
        let db = Firestore.firestore()
        try await db.collection(DatabaseNames.userTable).document(result.user.uid).setData(["id" : result.user.uid,"username" : userRequest.username , "email" : userRequest.email])
        
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
