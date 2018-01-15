//
//  User.swift
//  RPG
//
//  Created by Bernardo Sarto de Lucena on 12/29/17.
//  Copyright © 2017 Bernardo Sarto de Lucena. All rights reserved.
//

import UIKit

class Users: NSObject {
    
    var id: String?
    var age: String?
    var city: String?
    var country: String?
    var email: String?
    var gender: String?
    var name: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.age = dictionary["age"] as? String
        self.city = dictionary["city"] as? String
        self.country = dictionary["country"] as? String
        self.email = dictionary["email"] as? String
        self.gender = dictionary["gender"] as? String
        self.name = dictionary["name"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
}
