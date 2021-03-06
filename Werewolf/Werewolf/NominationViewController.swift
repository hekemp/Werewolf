//
//  NominationViewController.swift
//  Werewolf
//
//  Created by macbook_user on 11/2/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class NominationViewController: UIViewController, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var villageList : [[String]] = []
    
    var mcSession: MCSession!

    @IBOutlet weak var NominationTableView: UITableView!
    
    var voteList = GameSession.active.voteList
    
    var tempVoteList = [[String]]()
    
    var resultList = [String]()
    
    var myVote : Int!
    
    var myRole : String?
    
    var timer: Timer!
    
    @IBOutlet weak var nominateButton: UIButton!
    
    @IBOutlet weak var abstainButton: UIButton!
    
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
        super.viewWillAppear(animated)
        if let villageList = GameSession.active.villageList{
            self.villageList = villageList
        }
        if let mcSession = GameSession.active.mySession{
            self.mcSession = mcSession
        }
    }
    
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
        
        cell.textLabel!.font = UIFont (name: "Luminari-Regular", size: 17.0)
        
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
    
    @objc func updateStatus() {
        if GameSession.active.villageList!.count == GameSession.active.voteList.count {
            finalTally()
        }
    }
    
    func finalTally() {
        timer.invalidate()
        var countingVotes = [Int]()
        
        for _ in GameSession.active.villageList! {
            countingVotes.append(0)
        }
        
        
        
        // don't have to cover if a werewolf doesn't exist/0 votes, because if there are  0 werewolves
        // then the game ends before we get to this point
        var maxVotes = countingVotes.max()!
        
        
        var maxVotesLocation = countingVotes.index(of: maxVotes)!
        
        
        resultList.append(String(maxVotesLocation))
        
        GameSession.active.voteList.forEach { item in
            
            if(item[0] != "Abstain") {
                var isDup = false
                for myItem in tempVoteList{
                    if myItem[0] == item[0]{
                        isDup = true
                    }
                }
                if (!isDup)
                {
                    tempVoteList.append(item)
                    
                }
            }
        }
        
        GameSession.active.voteList = tempVoteList
        if (GameSession.active.voteList.isEmpty){
            
            performSegue(withIdentifier: "noNominations", sender: self)
            
        }
        else{
        performSegue(withIdentifier: "toVote", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        
        if(GameSession.active.voteList.isEmpty){
            
            let destVC: ExecuteViewController = segue.destination as! ExecuteViewController
            destVC.mcSession = mcSession
            destVC.villageList = GameSession.active.villageList!
            print(villageList)
        }
        else{
        let destVC: VoteViewController = segue.destination as! VoteViewController
            destVC.mcSession = mcSession
            destVC.villageList = GameSession.active.villageList!
            print(villageList)
            destVC.resultList = self.resultList
            print(resultList)
            destVC.voteList = GameSession.active.voteList
            print(voteList)
        }
        
    }
    
    @IBAction func nominateSelected(_ sender: Any) {
        
        let voteIndex:Int = (NominationTableView.indexPathForSelectedRow! as NSIndexPath).row
        myVote = voteIndex
        let vote:String = GameSession.active.villageList![voteIndex][0]
        print("vote is" + vote)
        NominationTableView.allowsSelection = false
        GameSession.active.voteList.append([vote,myRole!])
        Networking.shared.sendText(vote + "," + myRole!, prefixCode: "Nomination")
        nominateButton.isEnabled = false
        abstainButton.isEnabled = false
        
    }
    
    @IBAction func abstainButtonPressed(_ sender: Any) {
        
        let vote:String = "Abstain"
        print("vote is" + vote)
        NominationTableView.allowsSelection = false
        GameSession.active.voteList.append([vote,myRole!])
        Networking.shared.sendText(vote + "," + myRole!, prefixCode: "Nomination")
        nominateButton.isEnabled = false
        abstainButton.isEnabled  = false
    }
}
