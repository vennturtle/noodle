//
//  Question.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation

class Question {
    var prompt: String
    var type: QuestionType
    var options: [String]
    
    enum QuestionType{
        case TrueOrFalse
        case SingleSelection
        case MultipleSelection
        
        static func intToType(_ type: Int) -> QuestionType? {
            switch (type){
            case 0:
                return .TrueOrFalse
            case 1:
                return .SingleSelection
            case 2:
                return .MultipleSelection
            default:
                return nil
            }
        }
    }
    
    init(prompt: String, type: Int, options: [String]){
        self.prompt = prompt
        self.type = QuestionType.intToType(type)!
        self.options = options
    }
    
    convenience init(){
        self.init(prompt: "", type: 0, options: [""])
    }
}
