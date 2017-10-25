//
//  PlayerCharacter.swift
//  Werewolf
//
//  Created by macbook_user on 10/25/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
class PlayerCharacter{
    var name: String
    var age: String
    var gender: String
    var occupation: String
    var role: String
    init(name: String, age: String, gender: String, occupation: String, role: String){
        self.name = name
        self.age = age
        self.gender = gender
        self.occupation = occupation
        self.role = role
    }
}
