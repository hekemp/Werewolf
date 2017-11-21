//
//  DoctorViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/13/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation

import UIKit
import MultipeerConnectivity

class DoctorViewController: UIViewController, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    var resultList = [String]()
    
    var voteList = GameSession.active.doctorVoteList
    
    var timer: Timer!
    
    var myRole : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(DoctorViewController.updateStatus), userInfo: nil, repeats: true)
        let character = GameSession.active.myCharacter
        myRole = character?.role
    }
    
    @objc func updateStatus() {
        if GameSession.active.villageList!.count == GameSession.active.doctorVoteList.count {
            finalTally()
        }
    }
    
    func finalTally() {
        timer.invalidate()
        
        var countingVotes = [Int]()
        
        for _ in GameSession.active.villageList! {
            countingVotes.append(0)
        }
        
        
        for player in GameSession.active.doctorVoteList {
            if player[1] == "Doctor"{
                
                countingVotes[Int(player[0])!] += 1
                
            }
        }
        
        if(countingVotes.max()! != 0)
        
        {var maxVotes = countingVotes.max()!
        
        
        var maxVotesLocation = countingVotes.index(of: maxVotes)!
        
        
            resultList.append(String(maxVotesLocation))}
        
        else {
            resultList.append(String(-1))
        }
        
        print(resultList)
        
        performSegue(withIdentifier: "toPotion", sender: self)
        
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
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: PotionViewController = segue.destination as! PotionViewController
        destVC.mcSession = mcSession
        destVC.villageList = GameSession.active.villageList!
        destVC.resultList = self.resultList
        print(resultList)
        
        
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
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        // vote for self
        let voteIndex:Int = (tableView.indexPathForSelectedRow! as NSIndexPath).row
        tableView.allowsSelection = false
        GameSession.active.doctorVoteList.append([String(voteIndex),myRole!])
        Networking.shared.sendText(String(voteIndex) + "," + myRole!, prefixCode: "Doctor")
        confirmButton.isEnabled = false
    }
    
}

