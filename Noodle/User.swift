//
//  User.swift
//  Noodle
//
//  Created by Brandon Cecilio on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    var id: String?
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    init?(_ snapshot: FIRDataSnapshot){
        let id = snapshot.key
        guard let dict = snapshot.value as? [String: Any]   else { return nil }
        guard let name = dict["Name"] as? String            else { return nil }
        guard let email = dict["Email"] as? String          else { return nil }
        
        self.id = id
        self.name = name
        self.email = email
    }
    
    /*** STATIC FUNCTIONS FOR QUERYING FROM DATABASE ***/
    
    // download a user from the server by key, and then execute a callback on the retrieved data
    // this function passes in the downloaded User object to the included callback
    // (typically this callback is used to grab the data and update views with information)
    static func get(byID uid: String, dbref: FIRDatabaseReference, with: @escaping (User?) -> Void){
        dbref.child("Users/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
            let user = User(snapshot)
            
            if user != nil {
                print("Successfully retrieved user (key: \(uid)). Executing callback...")
            } else {
                print ("Error: could not retrieve user (key: \(uid). Executing callback...")
            }
            with(user)
        })
    }
}
