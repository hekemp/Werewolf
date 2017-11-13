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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    @objc func timeToMoveOn(){
        
        self.performSegue(withIdentifier: "transToSeer", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: SeerViewController = segue.destination as! SeerViewController
        destVC.mcSession = mcSession
        destVC.villageList = self.villageList
        
        
    }
}
