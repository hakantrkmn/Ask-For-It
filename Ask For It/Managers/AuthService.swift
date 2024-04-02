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
    
    public static func registerUser(with userRequest : RegisterUserRequest , completion: @escaping (Result<Bool, Error>)-> Void)
    {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error
            {
                completion(.failure(error))
                return
            }
            
            guard let resultUser = result?.user else { completion(.failure(error!)); return  }
            
            let db = Firestore.firestore()
            
            db.collection("users").document(resultUser.uid).setData(["username" : username , "email" : email]) { error in
                if let error = error
                {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
        }
    }
    
    public static func loginUser(with loginRequest : LoginUserRequest , completion: @escaping (Result<Bool,Error>) -> Void)
    {
        Auth.auth().signIn(withEmail: loginRequest.email, password: loginRequest.password) { Result, error in
            if let error = error
            {
                completion(.failure(error))
                return
            }
            else
            {
                
//                let db = Firestore.firestore()
//                let test = UserInfo(username: "hava", email: "hakan@gmail.com")
//            
//                db.collection("users").document(Result!.user.uid).updateData(test.dictionary) { error in
//                    if let error = error
//                    {
//                        completion(.failure(error))
//                        return
//                    }
//                    completion(.success(true))
//                }
//                
                
                completion(.success(true))
            }
            
        }
    }
    
    public static func logoutUser(completion: @escaping (Result<Bool?,Error>) -> Void)
    {
        do{
            try Auth.auth().signOut()
            completion(.success(nil))
        }catch let error
        {
            completion(.failure(error))
        }
        
        
        
    }
}
