//
//  humansWinViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/20/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class humansWinViewController: UIViewController {
    
    @IBOutlet weak var summaryText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
        let villageList = GameSession.active.villageList
        let mcSession = GameSession.active.mySession
        let dead = mcSession!.connectedPeers.count + 1 - villageList!.count
        summaryText.text = "Alive: " + String(villageList!.count) + "\nDead: " + String(dead)
        mcSession!.disconnect()
        GameSession.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
