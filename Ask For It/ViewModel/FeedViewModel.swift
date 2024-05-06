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
    
    func getQuestions() async throws
    {
        questions =  try await  NetworkService.shared.getRandomQuestions()!
        
    }
    
}
