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
import MultipeerConnectivity

class GameSession{
    static var active: GameSession {
        get {
            if let m = _active {
                return m
            } else {
                return GameSession()
            }
        }
    }
    static var _active : GameSession?
    var activeRoles = ["Villager","Doctor","Werewolf","Seer", "Witch"]
    var villageList : [[String]]?
    var villageName : String?
    var myCharacter: PlayerCharacter?
    var mySession: MCSession?
    var match: GKMatch?
    var initiative : Int?
    var rank : Int?
    var peersToGetInitiativeFrom : Int?
    var canUsePotion = true
    var canUsePoison = true
    var voteList : [[String]] = []
    var werewolfVoteList : [[String]] = []
    var seerVoteList : [[String]] = []
    var doctorVoteList : [[String]] = []
    var potionVoteList : [[String]] = []
    var poisonVoteList : [[String]] = []
    var killedList : [String] = []
    init(){
        GameSession._active = self
        print("Instantiating GameSession")
    }
    
}
