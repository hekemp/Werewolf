//
//  LobbyViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/11/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController, MCSessionDelegate {
    
    @IBOutlet weak var theLabel: UILabel!
    
    var timer: Timer!
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(villageList)
        mcSession.delegate = self
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "OpeningBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(LobbyViewController.updateLabel), userInfo: nil, repeats: true)
        
        updateLabel()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateLabel() {
        let newText = "Number of Players: " + String(mcSession.connectedPeers.count + 1)
        theLabel.text = newText
        
    }
    
    @IBAction func startGame(_ sender: Any) {
        timer.invalidate()
        performSegue(withIdentifier: "startCharacterCreation", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: CharacterCreationViewController = segue.destination as! CharacterCreationViewController
        if segue.identifier == "startCharacterCreation" {
            destVC.mcSession = mcSession
            destVC.villageList = self.villageList
            GameSession.active.villageList = self.villageList
            print("Village List!")
            print(GameSession.active.villageList)
            
            
        }
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
    
    
}

