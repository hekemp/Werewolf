//
//  ExecuteViewController.swift
//  Werewolf
//
//  Created by macbook_user on 11/2/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class ExecuteViewController: UIViewController {
    
    var villageList : [[String]] = []
    
    var mcSession: MCSession!
    
    var killedVillager = "Abstain"
    
    var humansAlive = 0
    
    var werewolvesAlive = 0
    
    @IBOutlet weak var killedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        
        if(killedVillager != "Abstain"){
        killedLabel.text = "Killed: " + killedVillager
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        
        if(humansAlive < werewolvesAlive){
            
        }
        else if(werewolvesAlive == 0){
          
        }
        else{
        let destVC: SeerViewController = segue.destination as! SeerViewController
        destVC.mcSession = mcSession
        destVC.villageList = self.villageList
        }
        
        
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
            self.performSegue(withIdentifier: "werewolfGameOver", sender: self)
        }
        else if(werewolvesAlive == 0){
            self.performSegue(withIdentifier: "villagerGameOver", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "transToSeer", sender: self)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        GameSession.active?.villageList = self.villageList
        GameSession.active?.mySession = self.mcSession
    }
}
