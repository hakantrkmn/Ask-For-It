//
//  AnswerQuestionViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation


class AnswerQuestionViewModel
{
    var questionId : String?
    var question : Question?
    
    func getQuestion()  async throws
    {
        question = try await NetworkService.shared.getQuestion(with: questionId!)
    }
    
    func answerQuestion(index : Int) async throws
    {
        guard let id = question?.option.first!.questionID else {return}
        try await NetworkService.shared.answerQuestion(with: id, optionIndex: index)
    }
    
    
}
