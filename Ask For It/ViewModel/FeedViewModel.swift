//
//  FeedViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation

class FeedViewModel
{
    var questions : [Question] = []
    
    func getQuestions(completion : @escaping () -> ())
    {
        NetworkService.shared.getRandomSnapshot(completion: { questionList in
            self.questions = questionList
            completion()
        })
    }
    
}
