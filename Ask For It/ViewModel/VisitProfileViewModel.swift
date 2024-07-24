//
//  VisitProfileViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 24.07.2024.
//

import Foundation

class VisitProfileViewModel
{
    var userID = ""
    var user : User?
    
    func getUser () async
    {
        
            do
            {
                user = try await NetworkService.shared.getUserInfo(with: userID)
            }
            catch let error
            {
                print(error)
            }


    }

}
