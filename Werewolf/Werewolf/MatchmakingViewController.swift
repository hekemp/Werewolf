//
//  MatchmakingViewController.swift
//  Werewolf
//
//  Created by macbook_user on 11/10/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import GameKit
class MatchmakingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersJoined.count
    }
    @IBOutlet weak var roomCodeDisplay: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.playersJoinedTable.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.playersJoined[indexPath.row].alias
        
        return cell
    }
    func doMatchMaking(){
        let req = GKMatchRequest()
        //req.playerGroup = (GameSession.active?.roomCode)!
        req.minPlayers = 3
        req.maxPlayers = 16
        req.inviteMessage = "join werewolf game?"
        req.recipientResponseHandler = self.playerDidAcceptRequest;
        let mm = GKMatchmaker()
        mm.findMatch(for: req, withCompletionHandler: matchFound)
    }
    func playerDidAcceptRequest(player: GKPlayer, response: GKInviteeResponse){
        if(GKInviteeResponse.inviteeResponseAccepted==response){
            playersJoined.append(player)
        }
    }
    func matchFound(match: GKMatch?, err: Error?){
        if let match = match{
            GameSession.active.match = match
            shouldPerformSegue(withIdentifier: "matched", sender: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        doMatchMaking()
    }
    
    @IBOutlet weak var playersJoinedTable: UITableView!
    var playersJoined : [GKPlayer] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.playersJoinedTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.roomCodeDisplay.text = "\(GameSession.active!.roomCode)"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
