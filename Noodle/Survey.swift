//
//  Survey.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase

class Survey: NSObject {
    var id: String?
    var title: String
    var desc: String
    var startDate: Date?
    var daysAvailable: Int
    var latitude: Double
    var longitude: Double
    var questions: [Question]
    var qids: [String]          // array of question keys associated with database nodes
    
    
    // client-side creation (you can omit questions and qids)
    init(title: String, desc: String, daysAvailable: Int, latitude: Double, longitude: Double, questions: [Question] = [], qids: [String] = []){
        self.title = title
        self.desc = desc
        self.daysAvailable = daysAvailable
        self.latitude = latitude
        self.longitude = longitude
        self.questions = questions
        self.qids = qids
    }
    
    // initialization from server snapshot
    init?(_ snapshot: FIRDataSnapshot, withDebugMessages debug: Bool = false){
        let id = snapshot.key
        if debug { print("Retrieving survey... (key: \(self.id!)") }
        guard let dict = snapshot.value as? [String:Any]        else { return nil }
        guard let title = dict["title"] as? String              else { return nil }
        guard let desc = dict["desc"] as? String                else { return nil }
        guard let startDateMillis = dict["startTime"] as? Int   else { return nil }
        guard let daysAvailable = dict["daysAvailable"] as? Int else { return nil }
        guard let latitude = dict["latitude"] as? Double        else { return nil }
        guard let longitude = dict["longitude"] as? Double      else { return nil }
        
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = Date(timeIntervalSince1970: Double(startDateMillis)/1000.0)
        self.daysAvailable = daysAvailable
        self.latitude = latitude
        self.longitude = longitude
        self.questions = []
        if debug { print("Survey retrieved successfully.") }
        self.qids = dict["questions"] as? [String] ?? []
    }
    
    // no-args empty init
    convenience override init(){
        self.init(title: "", desc: "", daysAvailable: 0, latitude: 0.0, longitude: 0.0)
    }
    
    // submits the survey if it currently has no key, returns the key of the newly stored survey
    func submitNewSurvey(dbref: FIRDatabaseReference, authorID: String, withDebugMessages debug: Bool = false) -> String? {
        guard self.id == nil else {
            print("Survey already exists in database. (key: \(self.id!))")
            return self.id!
        }
        
        // initialize node for survey to be stored at, and return the key
        self.id = dbref.child("Surveys").childByAutoId().key
        if debug { print("Submitting survey... (key: \(self.id!))") }
        
        // initializes nodes for every question and stores the associated keys
        let qnode = dbref.child("Questions")
        self.qids = self.questions.map { _ in qnode.childByAutoId().key }
        if debug { print("Obtained \(self.qids.count) keys for \(self.questions.count) questions.") }
        
        // represents a placeholder directive to firebase to later grab the current server time
        // (stored in database as number of milliseconds since the UNIX epoch)
        let currentDBTime = FIRServerValue.timestamp() as! [String:Any]
        
        let survey = ["uid": authorID,
                      "title": self.title,
                      "desc": self.desc,
                      "startTime": currentDBTime,
                      "daysAvailable": self.daysAvailable,
                      "latitude": self.latitude,
                      "longitude": self.longitude,
                      "questions": self.qids] as [String: Any]
        
        var childUpdates = ["/Surveys/\(self.id!)": survey,
                            "/Users/\(authorID)/surveys/\(self.id!)": true] as [String : Any]
        
        
        for (qid, q) in zip(self.qids, self.questions) {
            if debug { print("Submitting question... (key: \(qid))") }
            guard let question = q.value else {
                print("Survey submission aborted: invalid question")
                return nil
            }
            childUpdates["/Questions/\(qid)"] = question
            if debug { print("Survey successfully submitted to database. (key: \(qid))") }
        }
        dbref.updateChildValues(childUpdates)
        
        print("Survey successfully submitted to database. (key: \(self.id!))")
        return self.id!
    }
    
    func addQuestion(_ question: Question){
        questions.append(question)
    }
}
/* reference code
// retrieving all surveys stored in the database
print("\n\nCurrent Surveys:")
self.myRef.child("Surveys").observe(.value, with: { snapshot in
    for child in snapshot.children {
        let values = child as? FIRDataSnapshot
        let model = Survey(snapshot: values!)!
        print(model.id)
        print(model.title)
        print(model.startDate)
    }
})

// submitting a new survey to the database
var myRef = FIRDatabase.database().reference()
if let uid = FIRAuth.auth()?.currentUser?.uid{
    let startDate = FIRServerValue.timestamp() as! [String:Any]
    let key = myRef.child("Surveys").childByAutoId().key
    let survey = ["uid": uid,
                  "title": "A Study On Bananas",
                  "desc": "A formal study on the nature of bananas",
                  "startTime": startDate,
                  "daysAvailable": 1,
                  "latitude": 37.335,
                  "longitude": -121.819] as [String : Any]
    
    let childUpdates = ["/Surveys/\(key)": survey]
    myRef.updateChildValues(childUpdates)
}*/
