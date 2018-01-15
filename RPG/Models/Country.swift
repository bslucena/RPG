//
//  Country.swift
//  RPG
//
//  Created by Bernardo Sarto de Lucena on 12/27/17.
//  Copyright © 2017 Bernardo Sarto de Lucena. All rights reserved.
//

import Foundation
import Firebase

class Country {
    var country: String
    var cities: [String]
    
    init(country:String, cities:[String]) {
        self.cities = cities
        self.country = country
    }
    
}
