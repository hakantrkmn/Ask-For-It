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
    var index = 0
    func getQuestions(completion : @escaping () -> ())
    {
        index += 1
        NetworkService.shared.getRandomSnapshot(index : index,completion: { questionList in
            self.questions = questionList
            completion()
        })
    }
    
}
