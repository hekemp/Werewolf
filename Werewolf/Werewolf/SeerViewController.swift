//
//  SeerViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/13/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation

import UIKit
import MultipeerConnectivity

class SeerViewController: UIViewController, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    var voteList = GameSession.active?.seerVoteList
    
    var resultList = [String]()
    
    var myRole : String?
    
    var myVote : Int!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcSession.delegate = self
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(SeerViewController.updateStatus), userInfo: nil, repeats: true)
        let character = GameSession.active?.myCharacter
        myRole = character?.role

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func updateStatus() {
        if mcSession.connectedPeers.count + 1 == voteList?.count {
            finalTally()
        }
    }
    
    func finalTally() {
        timer.invalidate()
        
        let indexLocation = IndexPath(row: myVote, section: 0)
        
        let selectedCell = self.tableView.cellForRow(at: indexLocation)
        
        
        if myRole == "Seer" {
            let bgColorView = UIView()
            if villageList[myVote][1] == "Werewolf"{
                bgColorView.backgroundColor = UIColor.red
            }
            else{
                bgColorView.backgroundColor = UIColor.green
            }
            
            bgColorView.isOpaque = true
            bgColorView.alpha = 0.5
            selectedCell!.backgroundView = bgColorView
            selectedCell!.selectedBackgroundView = bgColorView
            
        }
        else {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.green
            bgColorView.isOpaque = true
            bgColorView.alpha = 0.5
            selectedCell!.backgroundView = bgColorView
            selectedCell!.selectedBackgroundView = bgColorView
            
        }
        
      
        
        
        
        
        timer = Timer.scheduledTimer(timeInterval:5.0, target:self, selector:#selector(SeerViewController.performSegueToWerewolf), userInfo: nil, repeats: false)
    }
    
    @objc func performSegueToWerewolf() {
        
        performSegue(withIdentifier: "toWerewolf", sender: self)
        
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
        let destVC: WerewolfViewController = segue.destination as! WerewolfViewController
        destVC.mcSession = mcSession
        destVC.villageList = self.villageList
        destVC.resultList = self.resultList
        
        
    }
    
    // Three required UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNum:Int = indexPath.row
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "customcell")! as UITableViewCell
        cell.textLabel!.text = villageList[cellNum][0]
        
        if (cellNum == 0) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    
        
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
    
    
    @IBAction func confirmSelected(_ sender: Any) {
        // vote for self
        let voteIndex:Int = (tableView.indexPathForSelectedRow! as NSIndexPath).row
        myVote = voteIndex
        let vote:String = villageList[voteIndex][0]
        tableView.allowsSelection = false
        self.voteList!.append([vote,myRole!])
        Networking.shared.sendText(vote + "," + myRole!, prefixCode: "Seer")
        confirmButton.isEnabled = false
    }
    
    
    //toWerewolf
    
}

