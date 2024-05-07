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
    
    
    func createQuestion(questionString : String ,with options : [String]) async throws -> String?
    {
        guard let user = Auth.auth().currentUser else {return nil}
        
        let question = QuestionQuery(userId: user.uid,title: questionString, optionIDs : [ ] , answeredUserIDs: [] ,createdAt: Date().timeIntervalSince1970)
        
        let questionDatabase = try db.collection(DatabaseNames.questionTable).addDocument(from: question)
        
        for i in 0..<options.count
        {
            let option = Option(title: options[i], questionId: questionDatabase.documentID, userIDs: [])
            let optionDatabase = try  db.collection(DatabaseNames.optionTable).addDocument(from: option)
            question.optionIDs.append(optionDatabase.documentID)
        }
        
        try await db.collection(DatabaseNames.questionTable).document(questionDatabase.documentID).updateData(question.dictionary)
        
        return questionDatabase.documentID
    }
    
    func answerQuestion(with questionId : String , optionIndex : Int) async throws
    {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let questionQuery = try await getQuestionQuery(with: questionId)
        let questionId = (try await getQuestion(with: questionId)).options.first?.questionId
        
        try await db.collection(DatabaseNames.questionTable).document(questionId!).updateData([
            "answeredUserIDs": FieldValue.arrayUnion([userId])
          ])
        try await db.collection(DatabaseNames.optionTable).document(questionQuery.optionIDs[optionIndex]).updateData([
            "userIDs": FieldValue.arrayUnion([userId])
          ])
        
    }
    
    func getQuestionQuery(with questionId : String) async throws -> QuestionQuery
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        let question = try await questionCollection.document(questionId).getDocument(as: QuestionQuery.self)
        
        return question
    }
    
    func getUserInfo(with userId : String) async throws -> User
    {
        let userCollection  = db.collection(DatabaseNames.userTable)
        
        let user = try await userCollection.document(userId).getDocument(as: User.self)
        
        return user
    }
    
    func updateQuestion(with questionId : String , newQuestion : QuestionQuery) async throws
    {
        try await db.collection(DatabaseNames.questionTable).document(questionId).updateData(newQuestion.dictionary)
    }
    
    func updateOption(with optionId : String , newOption : Option) async throws
    {
        try await db.collection(DatabaseNames.optionTable).document(optionId).updateData(newOption.dictionary)
    }
    
    func getQuestion(with questionId : String) async throws -> Question
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        let optionsCollection  = db.collection(DatabaseNames.optionTable) 
        
        let questionData = Question(userId: "", title: "", options: [], answeredUserIDs: [],createdAt: 10)
        
        let question = try await questionCollection.document(questionId).getDocument(as: QuestionQuery.self)
        questionData.userId = question.userId
        questionData.title = question.title
        questionData.createdAt = question.createdAt
        
        questionData.userInfo = try await getUserInfo(with: questionData.userId)
        
        for i in 0..<question.optionIDs.count
        {
            let option = try await optionsCollection.document(question.optionIDs[i]).getDocument(as: Option.self)
            questionData.options.append(option)
        }
        
        return questionData
    }
    
    func getOption(with optionId : String) async throws -> Option?
    {
        let optionsCollection  = db.collection(DatabaseNames.optionTable)
        
        let question = try await optionsCollection.document(optionId).getDocument(as: Option.self)
        return question
    }
    
   
    
    
    func getRandomQuestions() async throws -> [Question]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        guard let user = Auth.auth().currentUser else { return nil}
        var questions : [Question] = []
        let question = try await questionCollection.whereField("userId", isNotEqualTo: user.uid).getDocuments()
        
        for document in question.documents 
        {
            let doc = try document.data(as: QuestionQuery.self)
            if doc.answeredUserIDs.contains(user.uid)
            {
                continue
            }
            let questionData = Question(userId: doc.userId, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
            questionData.userInfo = try await getUserInfo(with: questionData.userId)
            
            
            for opt in doc.optionIDs
            {
                try await questionData.options.append(getOption(with: opt)!)
            }
            questions.append(questionData)
            
        }
        
        return questions
    }
    
    
    func getRandomSnapshot() -> [Question]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        guard let user = Auth.auth().currentUser else { return nil }
        let question =  questionCollection.whereField("userId", isNotEqualTo: user.uid).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            Task{
                var questions : [Question] = []
                
                for document in documents
                {
                    do{
                        let doc = try document.data(as: QuestionQuery.self)
                        if doc.answeredUserIDs.contains(user.uid)
                        {
                            continue
                        }
                        let questionData = Question(userId: doc.userId, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
                        
                        questionData.userInfo = try await self.getUserInfo(with: questionData.userId)
                        
                        
                        for opt in doc.optionIDs
                        {
                            try await questionData.options.append(self.getOption(with: opt)!)
                        }
                        questions.append(questionData)
                        
                    }
                    catch
                    {
                        return []
                    }
                    
                    
                }
                return questions
                
            }
            
            
            
            
        }
        
        
        return []

        
       
    }
    
    
}
