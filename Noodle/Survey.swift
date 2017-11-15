//
//  Survey.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Survey: NSObject {
    var id: String?
    var title: String
    var desc: String
    var startDate: Date?
    var daysAvailable: Int
    var latitude: Double
    var longitude: Double
    var questions: [Question]?
    
    init(title: String, desc: String, daysAvailable: Int, latitude: Double, longitude: Double){
        self.title = title
        self.desc = desc
        self.daysAvailable = daysAvailable
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(snapshot: FIRDataSnapshot){
        let id = snapshot.key
        guard let dict = snapshot.value as? [String:Any]            else { return nil }
        guard let title = dict["title"] as? String                  else { return nil }
        guard let desc = dict["desc"] as? String                    else { return nil }
        guard let startDateMillis = dict["startTime"] as? Int       else { return nil }
        guard let daysAvailable = dict["daysAvailable"] as? Int     else { return nil }
        guard let latitude = dict["latitude"] as? Double            else { return nil }
        guard let longitude = dict["longitude"] as? Double          else { return nil }
        
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = Date(timeIntervalSince1970: Double(startDateMillis)/1000.0)
        self.daysAvailable = daysAvailable
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience override init(){
        self.init(title: "", desc: "", daysAvailable: 0, latitude: 0.0, longitude: 0.0)
    }
    
    func submitNewSurvey(dbref: FIRDatabaseReference, authorID: String){
        let currentDBTime = FIRServerValue.timestamp() as! [String:Any]
        let surveyID = dbref.child("Surveys").childByAutoId().key
        let survey = ["uid": authorID,
                      "title": self.title,
                      "desc": self.description,
                      "startTime": currentDBTime,
                      "daysAvailable": self.daysAvailable,
                      "latitude": self.latitude,
                      "longitude": self.longitude] as [String: Any]
        
        let childUpdates = ["/Surveys/\(surveyID)": survey]
        dbref.updateChildValues(childUpdates)
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
