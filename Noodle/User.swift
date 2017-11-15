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
    
    init?(snapshot: FIRDataSnapshot){
        let id = snapshot.key
        guard let dict = snapshot.value as? [String: Any]   else { return nil }
        guard let name = dict["Name"] as? String            else { return nil }
        guard let email = dict["Email"] as? String          else { return nil }
        
        self.id = id
        self.name = name
        self.email = email
    }
}
