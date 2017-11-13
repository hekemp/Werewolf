//
//  NightSummaryViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 10/29/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class NightSummaryViewController: UIViewController {
    
    var humansAlive = 4
    var werewolvesAlive = 0
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timeToMoveOn() {
        if(humansAlive < werewolvesAlive){
            self.performSegue(withIdentifier: "goToVillagerGameOver", sender: self)
        }
        else if(werewolvesAlive == 0){
            self.performSegue(withIdentifier: "goToWerewolfGameOver", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "restartDay", sender: self)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        GameSession.active?.villageList = self.villageList
        GameSession.active?.mySession = self.mcSession
    }
    
    
}
