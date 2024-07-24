//
//  FollowerFeedViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 24.07.2024.
//

import Foundation

class FollowerFeedViewModel
{
    var questions : [Question] = []
    
    func getQuestions(completion : @escaping () -> ())
    {
        NetworkService.shared.getFollowingUsersRandomSnapshot(completion: { questionList in
            self.questions = questionList
            completion()
        })
    }
}
