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
    var questionID : String?
    func getQuestion() async throws
    {
        question = try await NetworkService.shared.getQuestion(with: questionID!)
    }
}
