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
    var hoursAvailable: Int
    var latitude: Double
    var longitude: Double
    
    init(title: String, desc: String, hoursAvailable: Int, latitude: Double, longitude: Double){
        self.title = title
        self.desc = desc
        self.hoursAvailable = hoursAvailable
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(snapshot: FIRDataSnapshot){
        let id = snapshot.key
        guard let dict = snapshot.value as? [String:Any]            else { return nil }
        guard let title = dict["title"] as? String                  else { return nil }
        guard let desc = dict["desc"] as? String                    else { return nil }
        guard let startDateMillis = dict["startTime"] as? Int       else { return nil }
        guard let hoursAvailable = dict["hoursAvailable"] as? Int   else { return nil }
        guard let latitude = dict["latitude"] as? Double            else { return nil }
        guard let longitude = dict["longitude"] as? Double          else { return nil }
        
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = Date(timeIntervalSince1970: Double(startDateMillis)/1000.0)
        self.hoursAvailable = hoursAvailable
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience override init(){
        self.init(title: "", desc: "", hoursAvailable: 0, latitude: 0.0, longitude: 0.0)
    }
    
    func submitNewSurvey(dbref: FIRDatabaseReference, authorID: String){
        let currentDBTime = FIRServerValue.timestamp() as! [String:Any]
        let key = dbref.child("Surveys").childByAutoId().key
        let survey = ["uid": authorID,
                      "title": self.title,
                      "desc": self.description,
                      "startTime": currentDBTime,
                      "hoursAvailable": self.hoursAvailable,
                      "latitude": self.latitude,
                      "longitude": self.longitude] as [String: Any]
        
        let childUpdates = ["/Surveys/\(key)": survey]
        dbref.updateChildValues(childUpdates)
    }
}
