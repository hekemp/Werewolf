//
//  GameSession.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//
//  A class for the UI to interface with the gamestate, which can include eventual networking

import Foundation
class GameSession{
    static var active : GameSession?
    var roomCode: Int
    var activeRoles = ["Villager","Doctor","Werewolf","Seer", "Witch"]
    var myCharacter: PlayerCharacter?
    init(roomToJoin roomCode: Int) {
        self.roomCode = roomCode
        GameSession.active = self
    }
    init(){
        roomCode = Int(arc4random_uniform(9999))
        GameSession.active = self
    }
}
