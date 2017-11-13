//
//  WerewolfViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/13/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation

import UIKit
import MultipeerConnectivity

class WerewolfViewController: UIViewController, MCSessionDelegate {
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    
    // This function should be CALLED when attempting to send the text
    func sendText(_ plainString: String) {
        print("Sending Data")
        if mcSession.connectedPeers.count > 0 {
            print("Sending Data 2")
            
            guard let plainData = (plainString as NSString).data(using: String.Encoding.utf8.rawValue) else {
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
                    present(ac, animated: true)
                }
            }
        }
    }
    
    
    // This function checks for if you are recieving data and if you are it executes
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        
        if data != nil {
            do {
                let actualString = String(data: data, encoding: String.Encoding.utf8)
                print(actualString)
                DispatchQueue.main.async { [unowned self] in
                    let characterArray = actualString!.components(separatedBy: ",")
                    
                    let name    = characterArray[0]
                    let role = characterArray[1]
                    self.villageList.append([name, role])
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: DoctorViewController = segue.destination as! DoctorViewController
        destVC.mcSession = mcSession
        destVC.villageList = self.villageList
        
        
    }
    
    
}

