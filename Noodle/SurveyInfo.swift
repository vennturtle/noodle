//
//  SurveyInfo.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase
import Foundation


class SurveyInfo: NSObject{
    var sid: String
    var title: String
    var desc: String
    var latitude: String
    var longitude: String
    var startTime: NSDate
    var endTime: NSDate
    
    
    
    init(sid: String, title: String, desc: String, startTime: NSDate, endTime: NSDate, latitude: String, longitude: String){
        self.sid = sid
        self.title = title
        self.desc = desc
        self.startTime = startTime
        self.endTime = endTime
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    func createSurvey(){
        
//        let key = 
        let survey = ["id": sid,
                      "title": title,
                      "decription": desc,
                      "startTime": startTime,
                      "endTime": endTime,
                      "latitude": latitude,
                      "longitude":longitude] as [String : Any]
        
        
        
        
    }

}


