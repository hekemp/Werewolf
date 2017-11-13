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
    
    var humansAlive = 0
    var werewolvesAlive = 0
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    var resultList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkStatus(){
        for player in villageList {
            if player[1] == "Werewolf"{
                werewolvesAlive = werewolvesAlive + 1
            }
            else{
                humansAlive = humansAlive + 1
            }
        }
        
    }
    
    @objc func timeToMoveOn() {
        
        checkStatus()
        
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
