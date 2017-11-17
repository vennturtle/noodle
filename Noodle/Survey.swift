//
//  Survey.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Survey: NSObject {
    var id: String?
    var uid: String?
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
    
    // initialization from server snapshot, fails if no associated questions are found
    init?(_ snapshot: FIRDataSnapshot, withDebugMessages debug: Bool = false){
        let id = snapshot.key
        if debug { print("Retrieving survey... (key: \(id))") }
        
        guard let dict = snapshot.value as? [String:Any]        else { return nil }
        guard let title = dict["title"] as? String              else { return nil }
        guard let desc = dict["desc"] as? String                else { return nil }
        guard let startDateMillis = dict["startTime"] as? Int   else { return nil }
        guard let daysAvailable = dict["daysAvailable"] as? Int else { return nil }
        guard let latitude = dict["latitude"] as? Double        else { return nil }
        guard let longitude = dict["longitude"] as? Double      else { return nil }
        
        guard let qids = dict["questions"] as? [String] else {
            print("Aborting survey retrieval: questions could not be found.")
            return nil
        }
        guard qids.count > 0 else {
            print("Aborting survey retrieval: questions could not be found.")
            return nil
        }
        if debug {
            print("Retrieved question keys. Call getQuestions() to download the questions from the database.")
        }
        
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = Date(timeIntervalSince1970: Double(startDateMillis)/1000.0)
        self.daysAvailable = daysAvailable
        self.latitude = latitude
        self.longitude = longitude
        self.questions = []
        self.qids = qids
        if debug { print("Survey retrieved successfully.") }
    }
    
    // no-args empty init
    convenience override init(){
        self.init(title: "", desc: "", daysAvailable: 0, latitude: 0.0, longitude: 0.0)
    }
    
    // submits the survey if it currently has no key, returns the key of the newly stored survey
    func submit(dbref: FIRDatabaseReference, authorID: String, withDebugMessages debug: Bool = false) -> String? {
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
        
        self.uid = authorID
        
        let survey = ["uid": self.uid!,
                      "title": self.title,
                      "desc": self.desc,
                      "startTime": currentDBTime,
                      "daysAvailable": self.daysAvailable,
                      "latitude": self.latitude,
                      "longitude": self.longitude,
                      "questions": self.qids] as [String: Any]
        
        var childUpdates = ["/Surveys/\(self.id!)": survey,
                            "/Users/\(self.uid!)/surveys/\(self.id!)": true] as [String : Any]
        
        for (qid, q) in zip(self.qids, self.questions) {
            if debug { print("Submitting question... (key: \(qid))") }
            guard let question = q.value else {
                print("Survey submission aborted: invalid question")
                return nil
            }
            childUpdates["/Questions/\(qid)"] = question
            if debug { print("Question successfully submitted to database. (key: \(qid))") }
        }
        dbref.updateChildValues(childUpdates)
        
        print("Survey successfully submitted to database. (key: \(self.id!))")
        return self.id!
    }
    
    // append a question to the question array
    func addQuestion(_ question: Question){
        questions.append(question)
    }
    
    // retrieve a question from the database, provided qids are available
    // you must include a callback that will execute after downloading is finished
    // (this callback is passed the new Question object, and can be used to update views with information)
    func getQuestion(dbref: FIRDatabaseReference, index: Int, with: @escaping (Question) -> Void){
        if qids.count > index {
            let qid = qids[index]
            dbref.child("Questions/\(qid)").observeSingleEvent(of: .value, with: { snapshot in
                if let question = Question(snapshot) {
                    with(question)
                }
            })
        } else { print("Error: Question \(index+1) does not exist for survey (key: \(self.id ?? "None")).") }
    }
    
    // download a survey from the server by key, and then execute a callback on the retrieved data
    // this function passes in the downloaded Survey object to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func get(byID sid: String, dbref: FIRDatabaseReference, with: @escaping (Survey?) -> Void){
        dbref.child("Surveys/\(sid)").observeSingleEvent(of: .value, with: { snapshot in
            let survey = Survey(snapshot)
            
            if survey != nil {
                print("Successfully retrieved survey (key: \(sid)). Executing callback...")
            } else {
                print ("Error: could not retrieve survey (key: \(sid). Executing callback...")
            }
            with(survey)
        })
    }
    
    // download all surveys by a specified user, then executes a callback on the retrieved data
    // this function passes in the downloaded Survey array to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func getAll(byUserID uid: String, dbref: FIRDatabaseReference, with: @escaping ([Survey]) -> Void){
        let ref = dbref.child("Surveys").queryOrdered(byChild: "uid").queryEqual(toValue: uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var surveys = [Survey]()
            for snap in snapshot.children {
                if let survey = Survey(snap as! FIRDataSnapshot) {
                    //print("Found survey (key: \(survey.id ?? "None"))")
                    surveys.append(survey)
                }
                else {
                    print("Could not retrieve survey (key: \((snap as? FIRDataSnapshot)?.key ?? "None"))")
                }
            }
            print("Retrieved \(surveys.count) survey(s) associated with user (key: \(uid)). Executing callback...")
            with(surveys)
        })
    }
    
    // download all surveys near a specified location, then executes a callback on the retrieved data
    // this function passes in the downloaded Survey array to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func getAll(near loc: CLLocation, radiusInKm: Double = 5.0, dbref: FIRDatabaseReference, with: @escaping ([Survey]) -> Void){
        let ref = dbref.child("Surveys")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var surveys = [Survey]()
            for snap in snapshot.children {
                if let survey = Survey(snap as! FIRDataSnapshot) {
                    let sloc = CLLocation(latitude: survey.latitude, longitude: survey.longitude)
                    let dist = loc.distance(from:sloc)
                    if dist <= radiusInKm * 1000 {
                        surveys.append(survey)
                    }
                }
            }
            let locStr = "(\(loc.coordinate.latitude), \(loc.coordinate.longitude))"
            print("Retrieved \(surveys.count) survey(s) within \(radiusInKm) km of \(locStr). Executing callback...")
            with(surveys)
        })
    }
}
