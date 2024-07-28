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
import FirebaseStorage

class NetworkService
{
    
    static let shared = NetworkService()
    let storage = Storage.storage()
    
    
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
            question.optionID.append(optionDatabase.documentID)
        }
        
        try await db.collection(DatabaseNames.questionTable).document(questionDatabase.documentID).updateData(question.dictionary)
        
        return questionDatabase.documentID
    }
    
    func unfollowUser(with unfollowUserId : String ) async throws
    {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        
        try await db.collection(DatabaseNames.userTable).document(userId).updateData([
            "followingUserID": FieldValue.arrayRemove([unfollowUserId])
        ])
        
        try await db.collection(DatabaseNames.userTable).document(unfollowUserId).updateData([
            "followedUserID": FieldValue.arrayRemove([userId])
        ])
        
        UserInfo.shared.user.followingUserID.remove(object: unfollowUserId)
        
    }
    
    func followUser(with followingUserId : String ) async throws
    {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        
        try await db.collection(DatabaseNames.userTable).document(userId).updateData([
            "followingUserID": FieldValue.arrayUnion([followingUserId])
        ])
        
        try await db.collection(DatabaseNames.userTable).document(followingUserId).updateData([
            "followedUserID": FieldValue.arrayUnion([userId])
        ])
        
        UserInfo.shared.user.followingUserID.append(followingUserId)
        
    }
    
    func answerQuestion(with questionId : String , optionIndex : Int) async throws
    {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let questionQuery = try await getQuestionQuery(with: questionId)
        let questionId = (try await getQuestion(with: questionId)).option.first?.questionID
        
        try await db.collection(DatabaseNames.questionTable).document(questionId!).updateData([
            "answeredUserID": FieldValue.arrayUnion([userId])
        ])
        try await db.collection(DatabaseNames.optionTable).document(questionQuery.optionID[optionIndex]).updateData([
            "votedUserID": FieldValue.arrayUnion([userId])
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
        var user = try await userCollection.document(userId).getDocument(as: User.self)
        let createdQuestions = try await getUserCreatedQuestionIDS(with: user)
        let answeredQuestions = try await getUserAnsweredQuestionIDS(with: user)
        
        user.createdQuestionID = createdQuestions!
        user.answeredQuestionID = answeredQuestions!
        
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
        questionData.createdUserID = question.createdUserID
        questionData.title = question.title
        questionData.createdAt = question.createdAt
        
        questionData.createdUserInfo = try await getUserInfo(with: questionData.createdUserID)
        
        for i in 0..<question.optionID.count
        {
            let option = try await optionsCollection.document(question.optionID[i]).getDocument(as: Option.self)
            questionData.option.append(option)
        }
        questionData.answeredUserID = question.answeredUserID
        return questionData
    }
    
    func getOption(with optionId : String) async throws -> Option?
    {
        let optionsCollection  = db.collection(DatabaseNames.optionTable)
        
        let question = try await optionsCollection.document(optionId).getDocument(as: Option.self)
        return question
    }
    func getUserCreatedQuestionIDS(with user : User) async throws -> [String]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        var questionIDS : [String] = []
        let question = try await questionCollection.whereField("createdUserID", isEqualTo: user.id).getDocuments()
        
        for document in question.documents
        {
            questionIDS.append(document.documentID)
        }
        
        return questionIDS
    }
    
    func getUserAnsweredQuestionIDS(with user : User) async throws -> [String]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        var questionIDS : [String] = []
        let question = try await questionCollection.whereField("answeredUserID", arrayContains: user.id).getDocuments()
        
        for document in question.documents
        {
            questionIDS.append(document.documentID)
            
        }
        
        return questionIDS
    }
    
    func getAllUsers() async throws -> [User]
    {
        var users : [User] = []
        let questionCollection  = db.collection(DatabaseNames.userTable)
        
        let snapshot = try await questionCollection.getDocuments()
        
        for document in snapshot.documents
        {
            users.append(try document.data(as: User.self))
        }
        
        return users
        
    }
    
    func getUserCreatedQuestions(with user : User) async throws -> [Question]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        var questions : [Question] = []
        let question = try await questionCollection.whereField("createdUserID", isEqualTo: user.id).getDocuments()
        
        for document in question.documents
        {
            let doc = try document.data(as: QuestionQuery.self)
            let questionData = Question(userId: doc.createdUserID, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
            questionData.createdUserInfo = try await getUserInfo(with: questionData.createdUserID)
            
            
            for opt in doc.optionID
            {
                try await questionData.option.append(getOption(with: opt)!)
            }
            questions.append(questionData)
            
        }
        
        return questions
    }
    
    func getUserAnsweredQuestions(with user : User) async throws -> [Question]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        var questions : [Question] = []
        let question = try await questionCollection.whereField("answeredUserID", arrayContains: user.id).getDocuments()
        
        for document in question.documents
        {
            let doc = try document.data(as: QuestionQuery.self)
            let questionData = Question(userId: doc.createdUserID, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
            questionData.createdUserInfo = try await getUserInfo(with: questionData.createdUserID)
            
            
            for opt in doc.optionID
            {
                try await questionData.option.append(getOption(with: opt)!)
            }
            questions.append(questionData)
            
        }
        
        return questions
    }
    
    
    
    
    func getRandomQuestions() async throws -> [Question]?
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        guard let user = Auth.auth().currentUser else { return nil}
        var questions : [Question] = []
        let question = try await questionCollection.whereField("createdUserID", isNotEqualTo: user.uid).getDocuments()
        
        for document in question.documents
        {
            let doc = try document.data(as: QuestionQuery.self)
            if doc.answeredUserID.contains(user.uid)
            {
                continue
            }
            let questionData = Question(userId: doc.createdUserID, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
            questionData.createdUserInfo = try await getUserInfo(with: questionData.createdUserID)
            
            
            for opt in doc.optionID
            {
                try await questionData.option.append(getOption(with: opt)!)
            }
            questions.append(questionData)
            
        }
        
        return questions
    }
    
    func getFollowingUsersRandomSnapshot(completion: @escaping (_ questionList: [Question]) -> ())
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        guard let user = Auth.auth().currentUser else { return completion([]) }
        _ =  questionCollection.whereField("createdUserID", isNotEqualTo: user.uid).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents
            else
            {
                print("Error fetching documents: \(error!)")
                return
            }
            Task
            {@MainActor in
                var questions : [Question] = []
                for document in documents
                {
                    
                    
                    do{
                        let doc = try document.data(as: QuestionQuery.self)
                        if !UserInfo.shared.user.followingUserID.contains(doc.createdUserID)
                        {
                            continue
                            
                        }
                        if doc.answeredUserID.contains(user.uid)
                        {
                            continue
                        }
                        let questionData = Question(userId: doc.createdUserID, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
                        
                        questionData.createdUserInfo = try await self.getUserInfo(with: questionData.createdUserID)
                        
                        
                        for opt in doc.optionID
                        {
                            try await questionData.option.append(self.getOption(with: opt)!)
                        }
                        
                        
                        questions.append(questionData)
                        
                    }
                    catch
                    {
                        
                    }
                }
                
                completion(questions)
            }
        }
        
        
    }
    
    
    func getRandomSnapshot(index : Int , completion: @escaping (_ questionList: [Question]) -> ())
    {
        let questionCollection  = db.collection(DatabaseNames.questionTable)
        
        guard let user = Auth.auth().currentUser else { return completion([]) }
        _ =  questionCollection.whereField("createdUserID", isNotEqualTo: user.uid).limit(to: 20 * index).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents
            else
            {
                print("Error fetching documents: \(error!)")
                return
            }
            Task
            {@MainActor in
                var questions : [Question] = []
                for document in documents
                {
                    do{
                        let doc = try document.data(as: QuestionQuery.self)
                        if doc.answeredUserID.contains(user.uid)
                        {
                            continue
                        }
                        let questionData = Question(userId: doc.createdUserID, title: doc.title, options: [] , answeredUserIDs: [] , createdAt: doc.createdAt)
                        
                        questionData.createdUserInfo = try await self.getUserInfo(with: questionData.createdUserID)
                        
                        
                        for opt in doc.optionID
                        {
                            try await questionData.option.append(self.getOption(with: opt)!)
                        }
                        
                        
                        questions.append(questionData)
                        
                    }
                    catch
                    {
                        
                    }
                }
                
                completion(questions)
            }
        }
        
        
    }
    
    func uploadUserPhoto(image : UIImage)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Image could not be converted to data")
            return
        }
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(UserInfo.shared.user.id).jpg")
        _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                print("Error uploading image: \(String(describing: error?.localizedDescription))")
                return
            }
            
            
        }
    }
    
    func downloadUserPhoto(userID : String , completion: @escaping (_ image: UIImage?) -> ())
    {
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(userID).jpg")
        
        // Resmi indirmek için URL'yi al
        imageRef.downloadURL { url, error in
            Task
            {
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    
                } else if let url = url {
                    // URL'den resmi indir ve imageView'da göster
                    
                    completion(await self.downloadImage(from:url))
                }
            }
        }
        
    }
    
    func downloadImage(from url: URL) async  -> UIImage?
    {
        do 
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data)
            {
                return image
            } 
            else
            {
                return nil
            }
        } 
        catch
        {
            return nil
        }
        
    }
    
    
}
