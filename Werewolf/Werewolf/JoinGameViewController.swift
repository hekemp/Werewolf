//
//  JoinGameViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity


class JoinGameViewController: UIViewController, UITextFieldDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var timer: Timer!
    
    var villageList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        Networking.shared.mcSession = self.mcSession
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
        
        

        
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(JoinGameViewController.updateStatus), userInfo: nil, repeats: true)
        let queue = OperationQueue()
        
        queue.addOperation() {
            // do something in the background
            RandomGenerators.gen
            
        }
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
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @IBAction func createRoomClick(_ sender: Any) {
        let joinGameConfirmation = UIAlertAction(title: "Join room #1", style: UIAlertActionStyle.default)
        
        startHosting(action: joinGameConfirmation)
        
        performSegueToCharacterCreation()

    }
    
    @IBAction func joinRoomClick(_ sender: Any) {
        let joinGameConfirmation = UIAlertAction(title: "Join room #1", style: UIAlertActionStyle.default)
        joinSession(action: joinGameConfirmation)
        
        //performSegueToCharacterCreation()
        
    }
    
    func performSegueToCharacterCreation() {
        performSegue(withIdentifier: "moveToCharacterCreation", sender: self)
        
        
        //moveToCharacterCreation
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: LobbyViewController = segue.destination as! LobbyViewController
        if segue.identifier == "moveToCharacterCreation" {
            destVC.mcSession = mcSession
            destVC.villageList = self.villageList
            
        }
        
    }
    
    @objc func updateStatus() {
        if mcSession.connectedPeers.count > 0 {
            performSegueToCharacterCreation()
        }
    }
    
    // func setText(_ input : String){
    //     DispatchQueue.main.async { // Correct
    //         self.text.text = input
    //     }
    //}
    
}
