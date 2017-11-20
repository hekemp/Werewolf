//
//  CharacterCreationLobby.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/12/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CharacterCreationLobby: UIViewController, UITableViewDelegate, UITableViewDataSource, MCSessionDelegate {
    
    @IBOutlet weak var villageListView: UITableView!
    
    var villageList = [[String]]()
    
    var mcSession: MCSession!
    
    var timer: Timer!
    
    var randomAge : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(villageList)
        mcSession.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(CharacterCreationLobby.updateStatus), userInfo: nil, repeats: true)

        self.villageList = GameSession.active.villageList!
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func updateStatus() {
 
        print("Status: ")
        print( GameSession.active.villageList)
        if mcSession.connectedPeers.count + 1 == GameSession.active.villageList?.count {
            print("Nyoom")
            performSegueToVillage()
        }
    }
    
    func performSegueToVillage() {
        performSegue(withIdentifier: "moveToVillage", sender: self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        randomAge = RandomGenerators.gen.getRandomAge() //static constructors are lazy, and making the generaterator takes a while, so force it to start sooner
    }
    override func viewWillDisappear(_ animated: Bool) {

        GameSession.active.mySession = self.mcSession
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Three required UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameSession.active.villageList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNum:Int = indexPath.row
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "customcell")! as UITableViewCell
        cell.textLabel!.text = GameSession.active.villageList![cellNum][0]
        return cell
    }
    
    // two optional UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("did select row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will select row \(indexPath.row)")
        return indexPath
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

