//
//  AnswerQuestionViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation


class AnswerQuestionViewModel
{
    var question : Question?
    
    func getQuestion(with questionId : String)  async throws
    {
            question = try await NetworkService.shared.getQuestion(with: questionId)
        
    }
    
    func answerQuestion(index : Int) async throws
    {
        guard let id = question?.options.first!.questionId else {return}
        try await NetworkService.shared.answerQuestion(with: id, optionIndex: index)

    }
    
    
}
