//
//  QuestionDetailViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation
import UIKit

class QuestionDetailViewModel
{
    var question : Question?
    
    init(question: Question? = nil , questionId : String) throws {
        self.question = question
        try getQuestion(with: questionId)
        
    }
    
    func getQuestion(with questionId : String) throws
    {
        Task
        {
            question = try await NetworkService.shared.getQuestion(with: questionId)   
        }
    }
}
