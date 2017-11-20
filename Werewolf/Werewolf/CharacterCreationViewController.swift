//
//  CharacterCreationViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/25/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class CharacterCreationViewController: UIViewController, MCSessionDelegate {
    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var ageField: UITextField?
    @IBOutlet weak var genderField: UITextField?
    @IBOutlet weak var occupationField: UITextField?
    
    var villageName : String?
    var villageList : [[String]]?
    var mcSession: MCSession!
    var roles = ["Werewolf", "Doctor", "Seer", "Witch", "Villager"]
    
    @IBAction func doRandomCharacterCreation(_ sender: Any) {
        let name = RandomGenerators.gen.getRandomName()
        let age = RandomGenerators.gen.getRandomAge()
        let gender = RandomGenerators.gen.getRandomGender()
        let occupation = RandomGenerators.gen.getRandomOccupation()
        var role : String
        if(GameSession.active?.rank! < roles.count){
            role = roles[(GameSession.active?.rank!)!]
        }
        else{
            if((GameSession.active?.rank!)!%5 == 0){
                role = "Werewolf"
            }
            else{
                role = "Villager"
            }
        }
        self.villageList!.append([name,role])
        Networking.shared.sendText(name + "," + role, prefixCode: "Playerdata")
        let _ = GameSession()
        GameSession.active?.myCharacter = PlayerCharacter(name: name, age: age, gender: gender, occupation: occupation, role: role)
        
    }
    @IBAction func doManualCharacterCreation(_ sender: Any) {
        let name = nameField?.text
        let age = ageField?.text
        let gender = genderField?.text
        let occupation = occupationField?.text
        var role : String
        if(GameSession.active?.rank! < roles.count){
            role = roles[(GameSession.active?.rank!)!]
        }
        else{
            if((GameSession.active?.rank!)!%5 == 0){
                role = "Werewolf"
            }
            else{
                role = "Villager"
            }
        }
        self.villageList!.append([name!, role])
        Networking.shared.sendText(name! + "," + role, prefixCode: "Playerdata")
        let _ = GameSession()
        GameSession.active?.myCharacter = PlayerCharacter(name: name!, age: age!, gender: gender!, occupation: occupation!, role: role)
        
    }
    func rollForInitiative(){
        //assign an increasing number to every user
        if(GameSession.active?.initiative == nil){
            GameSession.active?.initiative = Int(arc4random_uniform(UInt32.max))
            GameSession.active?.peersToGetInitiativeFrom = mcSession.connectedPeers.count
        }
        Networking.shared.sendText(String(describing: GameSession.active?.initiative!), prefixCode: "Initiative")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.villageList = GameSession.active?.villageList!
        GameSession.active?.rank = 0
        self.villageName = RandomGenerators.gen.getRandomVillageName()
        if(GameSession.active?.villageName==nil){
            Networking.shared.sendText(villageName!, prefixCode: "VillageName")
        }
        rollForInitiative()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Do not need to edit
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    // Do not need to edit
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    // Do not need to edit
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    // Do not need to edit
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // Do not need to edit
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // This code will execute when there's a change in state and it will update the block accordingly
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
    
    
    
    
    
    
    // This function checks for if you are recieving data and if you are it executes
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        Networking.shared.session(session, didReceive: data, fromPeer: peerID)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC: CharacterCreationLobby = segue.destination as! CharacterCreationLobby
        destVC.mcSession = mcSession
        destVC.villageList = self.villageList!
    }
    
    
}

