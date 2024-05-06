//
//  NetworkService.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 26.04.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class NetworkService
{
    
    static let shared = NetworkService()
    
    
    let db = Firestore.firestore()
    
    
    func createQuestion(questionString : String ,with options : [String]) throws -> String?
    {
        guard let user = Auth.auth().currentUser else {return nil}
        
        let question = QuestionQuery(userId: user.uid,title: questionString, optionIDs : [ ] , answeredUserIDs: [])
        
        do
        {
            let questionDatabase = try db.collection("Questions").addDocument(from: question)
            
            for i in 0..<options.count
            {
                let option = Option(title: options[i], questionId: questionDatabase.documentID, userIDs: [])
                let optionDatabase = try  db.collection("Options").addDocument(from: option)
                question.optionIDs.append(optionDatabase.documentID)
            }
            
            db.collection("Questions").document(questionDatabase.documentID).updateData(question.dictionary)
            return questionDatabase.documentID
        }
        catch
        {
            return nil
        }
        
    }
    
    func answerQuestion(with questionId : String , optionIndex : Int) async throws
    {
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        var questionQuery = try await getQuestionQuery(with: questionId)
        var questionId = (try await getQuestion(with: questionId)).options.first?.questionId
        var option = try await getOption(with: questionQuery.optionIDs[optionIndex])

        questionQuery.answeredUserIDs.append(userId)
        option?.userIDs.append(userId)
        
        
        try await db.collection("Questions").document(questionId!).updateData(questionQuery.dictionary)
        try await db.collection("Options").document(questionQuery.optionIDs[optionIndex]).updateData(option.dictionary)

        
        
        
    }
    
    func getQuestionQuery(with questionId : String) async throws -> QuestionQuery
    {
        let questionCollection  = db.collection("Questions")
        
        let question = try await questionCollection.document(questionId).getDocument(as: QuestionQuery.self)
        
        return question
        
        
    }
    
    func getUserInfo(with userId : String) async throws -> User
    {
        let userCollection  = db.collection("users")
        
        let user = try await userCollection.document(userId).getDocument(as: User.self)
        
        return user
        
        
    }
    
    func updateQuestion(with questionId : String , newQuestion : QuestionQuery) async throws
    {
        try await db.collection("Questions").document(questionId).updateData(newQuestion.dictionary)
    }
    
    func updateOption(with optionId : String , newOption : Option) async throws
    {
        try await db.collection("Options").document(optionId).updateData(newOption.dictionary)
    }
    
    func getQuestion(with questionId : String) async throws -> Question
    {
        let questionCollection  = db.collection("Questions")
        let optionsCollection  = db.collection("Options")
        
        let questionData = Question(userId: "", title: "", options: [], answeredUserIDs: [])
        
        let question = try await questionCollection.document(questionId).getDocument(as: QuestionQuery.self)
        questionData.userId = question.userId
        questionData.title = question.title
        
        for i in 0..<question.optionIDs.count
        {
            let option = try await optionsCollection.document(question.optionIDs[i]).getDocument(as: Option.self)
            questionData.options.append(option)
            
        }
        
        return questionData
        
        
    }
    
    func getOption(with optionId : String) async throws -> Option?
    {
        let optionsCollection  = db.collection("Options")
        
        let question = try await optionsCollection.document(optionId).getDocument(as: Option.self)
        return question
    }
    
    
    func getRandomQuestions() async throws -> [Question]?
    {
        let questionCollection  = db.collection("Questions")
        
        guard let user = Auth.auth().currentUser else { return nil}
        var questions : [Question] = []
        let question = try await questionCollection.whereField("userId", isNotEqualTo: user.uid).getDocuments()
        
        for document in question.documents {
            let doc = try document.data(as: QuestionQuery.self)
            let questionData = Question(userId: doc.userId, title: doc.title, options: [] , answeredUserIDs: [])
            for opt in doc.optionIDs
            {
                try await questionData.options.append(getOption(with: opt)!)
            }
            questions.append(questionData)
        }
        
        return questions
    }
    
    
}
