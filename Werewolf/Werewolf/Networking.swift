//
//  Networking.swift
//  Werewolf
//
//  Created by macbook_user on 11/19/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Networking{
    var mcSession : MCSession?
    static let shared = Networking()
    private init(){
        
    }
    
    func sendText(_ plainString: String, prefixCode: String) {
        print("Sending Data")
        if let mcSession = mcSession{
            if mcSession.connectedPeers.count > 0 {
                print("Sending Data 2")
            
                guard let plainData = ("\(prefixCode),\(plainString)" as NSString).data(using: String.Encoding.utf8.rawValue) else {
                    fatalError()
                }
            
                let base64String = (plainData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
                if  let data = Data.init(base64Encoded: base64String){
                    do {
                        print("Sending Data 3")
                        try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                    
                    } catch let error as NSError {
                        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        //present(ac, animated: true)
                    }
                }
            }
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        
        if data != nil {
            do {
                let actualString = String(data: data, encoding: String.Encoding.utf8)
                print(actualString)
                DispatchQueue.main.async { [unowned self] in
                    let characterArray = actualString!.components(separatedBy: ",")
                    let prefixCode = characterArray[0]
                    print(prefixCode)
                    
                    if(prefixCode=="initiative"){
                        let otherInitiative = Int(characterArray[1])!
                        if(GameSession.active.initiative == nil){
                            GameSession.active.initiative = Int(arc4random_uniform(UInt32.max))
                            GameSession.active.peersToGetInitiativeFrom = self.mcSession?.connectedPeers.count
                            
                        }
                        if((GameSession.active.initiative!)>otherInitiative){
                            GameSession.active.rank! += 1
                        }
                        GameSession.active.peersToGetInitiativeFrom! -= 1
                    }
                    else if(prefixCode=="Gameover"){
                        print(characterArray)
                        GameSession.active.gameOver = true
                        GameSession.active.gameWinner = characterArray[1]
                        GameSession.active.gameSurvivors = characterArray[2]
                    }
                    else if(prefixCode=="Playerdata"){
                        print(actualString!)
                        let name = characterArray[1]
                        let role = characterArray[2]
                        print(GameSession.active.villageList)
                        GameSession.active.villageList!.append([name, role])
                    }
                    else if(prefixCode=="VillageName"){
                        print("Got village")
                        print(characterArray[1])
                        if(GameSession.active.villageName==nil){
                            print("Setting village name!")
                            GameSession.active.villageName=characterArray[1]
                            print(GameSession.active.villageName)
                        }
                    }
                    else if(prefixCode=="Nomination"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.voteList.append([name, role])
                    }
                    else if(prefixCode=="Vote"){
                        let name    = characterArray[1]
                        GameSession.active.killedList.append(name)
                    }
                    else if(prefixCode=="Seer"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.seerVoteList.append([name, role])
                    }
                    else if(prefixCode=="Werewolf"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.werewolfVoteList.append([name, role])
                    }
                    else if(prefixCode=="Doctor"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.doctorVoteList.append([name, role])
                    }
                    else if(prefixCode=="Potion"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.potionVoteList.append([name, role])
                    }
                    else if(prefixCode=="Poison"){
                        let name    = characterArray[1]
                        let role = characterArray[2]
                        GameSession.active.poisonVoteList.append([name, role])
                    }
                }
            }
}
}
}
