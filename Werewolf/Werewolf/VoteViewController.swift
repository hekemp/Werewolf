//
//  VoteViewController.swift
//  Werewolf
//
//  Created by macbook_user on 11/2/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class VoteViewController: UIViewController, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var villageList : [[String]] = []
    
    var countArray : [[String]] = []
    
    var mcSession: MCSession!
    
    var voteList = [[String]]()
    
    var tempVillageList = [[String]]()
    
    var killedList = GameSession.active.killedList

    var tempKilledList = [String]()
    
    var resultList = [String]()
    
    var myVote : Int!
    
    var myRole : String?
    
    var killedVillager : String?
    
    var timer: Timer!
    
    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var abstainButton: UIButton!
    
    @IBOutlet weak var VoteTableView: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameSession.active.voteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNum:Int = indexPath.row
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "customcell")! as UITableViewCell
        cell.textLabel!.text = GameSession.active.voteList[cellNum][0]
        if (cellNum == 0) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        cell.textLabel!.font = UIFont (name: "Luminari-Regular", size: 17.0)
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "AfternoonBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(NominationViewController.updateStatus), userInfo: nil, repeats: true)
        let character = GameSession.active.myCharacter
        myRole = character?.role
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @objc func updateStatus() {
        print(GameSession.active.villageList!.count)
        print(GameSession.active.killedList.count)
        if GameSession.active.villageList!.count == GameSession.active.killedList.count {
            finalTally()
        }
    }
    
    func finalTally() {
        timer.invalidate()
        var countingVotes = [Int]()
        
        for _ in GameSession.active.villageList! {
            countingVotes.append(0)
        }
        
        var maxVotes = countingVotes.max()!
        print("maxvotes")
        print(maxVotes)
        
        var maxVotesLocation = countingVotes.index(of: maxVotes)!

        
        resultList.append(String(maxVotesLocation))
        
        GameSession.active.killedList.forEach { item in
            
            if(item != "Abstain" ){
                tempKilledList.append(item)
            }
            else{
                killedVillager = "Abstain"
            }
        }
        GameSession.active.killedList = tempKilledList
        
        let countedSet = NSCountedSet(array: GameSession.active.killedList)
        let mostFrequent = countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) }
        
        GameSession.active.villageList!.forEach { item in
            
            if(String(describing: mostFrequent) != "Optional(" + item[0] + ")") {
                tempVillageList.append(item)
            }
            else{
                killedVillager = item[0]
            }
        }
        
        GameSession.active.villageList = tempVillageList
        

        performSegue(withIdentifier: "toResults", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: ExecuteViewController = segue.destination as! ExecuteViewController
        destVC.mcSession = mcSession
        destVC.villageList = GameSession.active.villageList!
        print(villageList)
        destVC.killedVillager = self.killedVillager!
        print(killedVillager)
        
        
    }
    
    @IBAction func voteButtonPressed(_ sender: Any) {
        
        let voteIndex:Int = (VoteTableView.indexPathForSelectedRow! as NSIndexPath).row
        myVote = voteIndex
        let vote:String = GameSession.active.voteList[voteIndex][0]
        print("vote is" + vote)
        VoteTableView.allowsSelection = false
        GameSession.active.killedList.append(vote)
        Networking.shared.sendText(vote, prefixCode: "Vote")
        voteButton.isEnabled = false
        abstainButton.isEnabled = false
    }
    
    @IBAction func abstainButtonPressed(_ sender: Any) {
        
        let vote:String = "Abstain"
        print("vote is" + vote)
        VoteTableView.allowsSelection = false
        GameSession.active.killedList.append(vote)
        Networking.shared.sendText(vote, prefixCode: "Vote")
        voteButton.isEnabled = false
        abstainButton.isEnabled  = false
        
    }
    
    
}
