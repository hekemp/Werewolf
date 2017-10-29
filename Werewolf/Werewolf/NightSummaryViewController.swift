//
//  NightSummaryViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 10/29/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
class NightSummaryViewController: UIViewController {
    
    var humansAlive = 1
    var werewolvesAlive = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        
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
    
    
}
