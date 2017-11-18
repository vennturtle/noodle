//
//  Question.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase

class Question: NSObject {
    var id: String?
    var prompt: String
    var type: QuestionType
    var options: [String]
    
    // specifies question type
    enum QuestionType: Int{
        case TrueOrFalse = 0, SingleSelection, MultipleSelection
    }
    
    // maps integers to question types
    static let typeDict = [0: .TrueOrFalse,
                           1: .SingleSelection,
                           2: .MultipleSelection] as [Int:QuestionType]
    
    // returns instance variables as a dictionary for sending to firebase
    var value: [String:Any]? {
        guard prompt.characters.count > 0 else {
            print("Error: question prompt cannot be empty")
            return nil
        }
        var dict = ["prompt": prompt,
                    "type": type.rawValue] as [String:Any]
        
        switch(type){ // decide if we should add options
        case .TrueOrFalse:
            guard options.count == 0 else {
                print("Error: true-or-false questions cannot have \(options.count) options")
                return nil
            }
        default:
            guard options.count > 0 else {
                print("Error: missing options")
                return nil
            }
            dict["options"] = options
        }
        return dict
    }
    
    // client-side creation
    init(prompt: String, type: QuestionType, options: [String] = []){
        self.prompt = prompt
        self.type = type
        self.options = options
    }
    
    // initialization from server snapshot
    init?(_ snapshot: FIRDataSnapshot, withDebugMessages debug: Bool = false){
        let id = snapshot.key
        if debug { print("Retrieving question... (key: \(self.id!)") }
        
        guard let dict = snapshot.value as? [String:Any]    else { return nil }
        guard let prompt = dict["prompt"] as? String        else { return nil }
        guard let type = dict["type"] as? Int               else { return nil }
        guard let options = dict["options"] as? [String]    else { return nil }
        if debug { print("Question options returned successfully.") }
        
        self.id = id
        self.prompt = prompt
        self.type = Question.typeDict[type]!
        self.options = options
        if debug { print("Question returned successfully.") }
    }
    
    // lazy client-side creation (returns nil if type is invalid)
    convenience init?(prompt: String, type: Int, options: [String] = []){
        guard 0...2 ~= type else {
            print ("Invalid question type: \(type) (must be in range 0-2)")
            return nil
        }
        let qtype = Question.typeDict[type]!
        self.init(prompt: prompt, type: qtype, options: options)
    }
    
    // no-args empty init
    convenience override init(){
        self.init(prompt: "", type: 0, options: [])!
    }
    
    /*** STATIC FUNCTIONS FOR QUERYING FROM DATABASE ***/
    
    // download a question from the server by key, and then executes a callback on the retrieved data
    // this function passes in the downloaded Question object to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func get(byID qid: String, dbref: FIRDatabaseReference, with: @escaping (Question?) -> Void){
        dbref.child("Questions/\(qid)").observeSingleEvent(of: .value, with: { snapshot in
            let question = Question(snapshot)
            
            if question != nil {
                print("Successfully retrieved question (key: \(qid)). Executing callback...")
            } else {
                print ("Error: could not retrieve question (key: \(qid). Executing callback...")
            }
            with(question)
        })
    }
}
