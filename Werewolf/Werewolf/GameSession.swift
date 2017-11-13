//
//  GameSession.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//
//  A class for the UI to interface with the gamestate, which can include eventual networking

import Foundation
import GameKit
class GameSession{
    static var active : GameSession?
    var activeRoles = ["Villager","Doctor","Werewolf","Seer", "Witch"]
    var villageList : [[String]]?
    var myCharacter: PlayerCharacter?
    var match: GKMatch?
    init(){
        GameSession.active = self
    }
}
