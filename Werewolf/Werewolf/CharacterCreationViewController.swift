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
    var roles = [String]()
    
    
    @IBAction func doRandomCharacterCreation(_ sender: Any) {
        let name = RandomGenerators.gen.getRandomName()
        let age = RandomGenerators.gen.getRandomAge()
        let gender = RandomGenerators.gen.getRandomGender()
        let occupation = RandomGenerators.gen.getRandomOccupation()
        
        if(mcSession.connectedPeers.count + 1 == 1){
            roles.append("Villager")
        }
        else if(mcSession.connectedPeers.count + 1 == 2){
            roles.append(contentsOf: ["Villager", "Werewolf"])
        }
        else if(mcSession.connectedPeers.count + 1 == 3){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer"])
        }
        else if(mcSession.connectedPeers.count + 1 == 4){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer", "Doctor"])
        }
        else if(mcSession.connectedPeers.count + 1 == 5){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer", "Doctor", "Witch"])
        }
        else{
            roles.append(contentsOf: ["Werewolf", "Seer", "Doctor", "Witch", "Werewolf"])
            while(mcSession.connectedPeers.count + 1 > roles.count){
                roles.append("Villager")
            }
        }
        
        for villager in GameSession.active.villageList! {
            let location = roles.index(of: villager[1])
            if (location != nil){
                roles.remove(at: location!)
            }
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(roles.count)))
        
        let role = roles[randomIndex]
        
        roles.remove(at: randomIndex)

        //print(GameSession.active.rank)
        
        //if((GameSession.active.rank)! < roles.count){
        //    role = roles[(GameSession.active.rank!)]
        //}
        //else{
        //    if((GameSession.active.rank)!%5 == 0){
        //        role = "Werewolf"
       //     }
       //     else{
       //         role = "Villager"
       //     }
       // }
        GameSession.active.villageList!.append([name, role])
        Networking.shared.sendText(name + "," + role, prefixCode: "Playerdata")
       // let _ = GameSession()
        GameSession.active.myCharacter = PlayerCharacter(name: name, age: age, gender: gender, occupation: occupation, role: role)
        
        if(GameSession.active.villageName==nil){
            GameSession.active.villageName = villageName
            Networking.shared.sendText(villageName!, prefixCode: "VillageName")
        }
        
    }
    @IBAction func doManualCharacterCreation(_ sender: Any) {
        let name = nameField?.text
        let age = ageField?.text
        let gender = genderField?.text
        let occupation = occupationField?.text
        
        if(mcSession.connectedPeers.count + 1 == 1){
            roles.append("Villager")
        }
        else if(mcSession.connectedPeers.count + 1 == 2){
            roles.append(contentsOf: ["Villager", "Werewolf"])
        }
        else if(mcSession.connectedPeers.count + 1 == 3){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer"])
        }
        else if(mcSession.connectedPeers.count + 1 == 4){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer", "Doctor"])
        }
        else if(mcSession.connectedPeers.count + 1 == 5){
            roles.append(contentsOf: ["Villager", "Werewolf", "Seer", "Doctor", "Werewolf"])
        }
        else{
            roles.append(contentsOf: ["Werewolf", "Seer", "Doctor", "Witch"])
            while(mcSession.connectedPeers.count + 1 > roles.count){
                roles.append("Villager")
            }
        }
        
        for villager in GameSession.active.villageList! {
            let location = roles.index(of: villager[1])
            if (location != nil){
                roles.remove(at: location!)
            }
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(roles.count)))
        
        let role = roles[randomIndex]
        
        roles.remove(at: randomIndex)
        
        /*if((GameSession.active.rank!) < roles.count){
            role = roles[(GameSession.active.rank!)]
        }
        else{
            if((GameSession.active.rank!)%5 == 0){
                role = "Werewolf"
            }
            else{
                role = "Villager"
            }
        }*/

        GameSession.active.villageList!.append([name!, role])
        Networking.shared.sendText(name! + "," + role, prefixCode: "Playerdata")
        //let _ = GameSession()
        GameSession.active.myCharacter = PlayerCharacter(name: name!, age: age!, gender: gender!, occupation: occupation!, role: role)
        
        print(GameSession.active.villageName)
        if(GameSession.active.villageName==nil){
            GameSession.active.villageName = villageName
            Networking.shared.sendText(villageName!, prefixCode: "VillageName")
        }
        
    }
   /* func rollForInitiative(){
        //assign an increasing number to every user
        if(GameSession.active.initiative == nil){
            GameSession.active.initiative = Int(arc4random_uniform(UInt32.max))
            GameSession.active.peersToGetInitiativeFrom = mcSession.connectedPeers.count
        }
        Networking.shared.sendText(String(describing: GameSession.active.initiative!), prefixCode: "Initiative")
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(GameSession.active.villageList)
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "OpeningBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.villageList = GameSession.active.villageList!
        GameSession.active.rank = 0
        print(villageList)
        print("Loaded")
        print(GameSession.active.rank)
        self.villageName = RandomGenerators.gen.getRandomVillageName()
        
        //rollForInitiative()
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
        //destVC.villageList = self.villageList!
    }
    
    
}

