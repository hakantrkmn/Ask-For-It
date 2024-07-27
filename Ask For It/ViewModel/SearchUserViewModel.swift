//
//  SearchUserViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 27.07.2024.
//

import Foundation

class SearchUserViewModel
{
    var users : [User] = []
    var filteredUsers : [User] = []
    
    func getAllUsers () async throws
    {
        users = try await NetworkService.shared.getAllUsers()
        users.removeAll { user in
            user.id == UserInfo.shared.user.id
        }
        filteredUsers = users
    }
    
    func filterUsers(searchText : String)
    {
        if searchText.isEmpty
        {
            filteredUsers = users
            
        }
        else
        {
            filteredUsers = users.filter{$0.username.lowercased().contains(searchText.lowercased())}
        }
    }
}
