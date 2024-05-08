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
    
    func getQuestion(with questionId : String) async throws
    {
        question = try await NetworkService.shared.getQuestion(with: questionId)
    }
}
