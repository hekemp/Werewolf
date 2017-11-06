//
//  GameSession.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//
//  A class for the UI to interface with the gamestate, which can include eventual networking
import MultipeerConnectivity
import Foundation
class GameSession: NSObject, MCSessionDelegate{
    
    
    
    static var active : GameSession?
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var serviceType: String!
    var roomCode: Int
    var activeRoles = ["Villager","Doctor","Werewolf","Seer", "Witch"]
    var myCharacter: PlayerCharacter?
    init(roomToJoin roomCode: Int) {
        self.roomCode = roomCode
        super.init()
        GameSession.active = self
        self.initializeSession()
    }
    override init(){
        roomCode = Int(arc4random_uniform(9999))
        super.init()
        GameSession.active = self
        self.initializeSession()
    }
    func roomCodeDisplay() -> String{
        return String(format: "%04d", roomCode)

    }
    func initializeSession(){
         
        serviceType = "wrwolf-rm-\(roomCodeDisplay())"
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        
    }
    func createRoom(action: UIAlertAction){
        
    }
    func joinRoom(action: UIAlertAction){
        
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
