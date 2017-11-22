//
//  Answers.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/16/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase

class Answer: NSObject {
    var id: String?
    var uid: String?
    var sid: String?
    var choices: [Set<Int>]
    
    // client-side creation
    init(choices: [Set<Int>] = []){
        self.choices = choices
    }
    
    // default client-side creation, starts with an empty array of choices selected
    convenience override init(){
        self.init(choices: [])
    }
    
    // initialization from server snapshot
    init?(_ snapshot: FIRDataSnapshot, withDebugMessages debug: Bool = false){
        let id = snapshot.key
        if debug { print("Retrieving answer... (key: \(self.id!)") }
        
        guard let dict = snapshot.value as? [String:Any]            else { return nil }
        guard let uid = dict["uid"] as? String                      else { return nil }
        guard let sid = dict["sid"] as? String                      else { return nil }
        if debug { print("Retrieved uid (\(uid)) and sid (\(sid))") }
        
        guard let choiceDicts = dict["choices"] as? [[Int:Bool]] else { return nil }
        if debug { print("Retrieved choices as [[Int:Bool]]. Converting this dict to [Set<Int>]...") }
        let choices = choiceDicts.map { return Set<Int>($0.keys) }
        
        self.id = id
        self.uid = uid
        self.sid = sid
        self.choices = choices
        if debug { print("Survey returned successfully.") }
    }
    
    // append multiple user-selected answers for a question to the choices array
    // applies if question type was .MultipleSelection
    func append(choices: [Int]){
        self.choices.append(Set<Int>(choices))
    }
    
    // append single user-selected answer for a question to the choices array
    // applies if question type was .TrueOrFalse or .SingleSelection
    func append(choice: Int){
        self.append(choices: [choice])
    }
    
    // submits this answer to the database, unless the user has already answered this survey
    func submit(dbref: FIRDatabaseReference, userID: String, surveyID: String, withDebugMessages debug: Bool = false) {
        
        // defines callback that submits the answer once the submission is validated
        func submitAnswer(dbref: FIRDatabaseReference, userID: String, surveyID: String,withDebugMessages debug: Bool = false){
            
            // convert [Set<Int>] choices into [[Int:Bool]] format Firebase expects
            let choiceDicts = self.choices.map { (set: Set<Int>) -> [Int:Bool] in
                var dict = [Int:Bool]()
                for el in set { dict[el] = true }
                return dict
            }
            
            self.id = dbref.child("Answers").childByAutoId().key
            let answer = ["uid": userID,
                          "sid": surveyID,
                          "choices": choiceDicts] as [String:Any]
            let childUpdates = ["Answers/\(self.id!))": answer,
                                "Surveys/\(surveyID)/answeredBy/\(userID)": true] as [String:Any]
            dbref.updateChildValues(childUpdates)
            print("Answer successfully submitted to database. (key: \(self.id!))")
        }
        
        // check if the user has already submitted an answer to this survey
//        let ref = dbref.child("Surveys/\(surveyID)/answeredBy/\(userID)")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            if snapshot.value != nil {
//                print("Aborting answer submission: user already answered survey")
//            } else {
//                submitAnswer(dbref:dbref, userID:userID, surveyID:surveyID, withDebugMessages: debug)
//            }
//        })
    }
    
    // given an array of answers and a question, finds how many times every possible choice was picked
    // (e.g. for a T/F question with 18 answers, this might return [7, 11] where choice 0 means true)
    // if you're analyzing question one, ofQuestion = 1
    static func getFrequency(ofQuestion indexPlusOne:Int, from answers: [Answer]) -> [Int]? {
        let question = indexPlusOne - 1
        guard answers.count > 0 else        { return nil }
        
        let numChoices = answers[0].choices.count
        guard question < numChoices else    { return nil }
        
        // will store choice frequencies, initialize each to 0
        var picked = [Int](repeating: 0, count: numChoices)
        for answer in answers {
            for choice in 0..<numChoices {
                if answer.choices[question].contains(choice){
                    picked[choice] += 1
                }
            }
        }
        return picked
    }
    
    /*** STATIC FUNCTIONS FOR QUERYING FROM DATABASE ***/
    
    // download all answers for a specified survey, then executes a callback on the retrieved data
    // this function passes in the downloaded Answer array to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func getAll(bySurveyID sid: String, dbref: FIRDatabaseReference, with: @escaping ([Answer]) -> Void){
        let ref = dbref.child("Answers").queryOrdered(byChild: "sid").queryEqual(toValue: sid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var answers = [Answer]()
            for snap in snapshot.children {
                if let ans = Answer(snap as! FIRDataSnapshot) {
                    answers.append(ans)
                }
                else {
                    print("Could not retrieve answer (key: \((snap as? FIRDataSnapshot)?.key ?? "None"))")
                }
            }
            print("Retrieved \(answers.count) answer(s) associated with survey (key: \(sid)). Executing callback...")
            with(answers)
        })
    }
    
    // download all answers by a certain user, then executes a callback on the retrieved data
    // this function passes in the downloaded Answer array to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func getAll(byUserID uid: String, dbref: FIRDatabaseReference, with: @escaping ([Answer]) -> Void){
        let ref = dbref.child("Answers").queryOrdered(byChild: "uid").queryEqual(toValue: uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var answers = [Answer]()
            for snap in snapshot.children {
                if let ans = Answer(snap as! FIRDataSnapshot) {
                    answers.append(ans)
                }
                else {
                    print("Could not retrieve answer (key: \((snap as? FIRDataSnapshot)?.key ?? "None"))")
                }
            }
            print("Retrieved \(answers.count) answer(s) associated with user (key: \(uid)). Executing callback...")
            with(answers)
        })
    }
}
