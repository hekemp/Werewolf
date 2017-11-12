//
//  LobbyViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/11/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var theLabel: UILabel!
    
    var timer: Timer!
    
    var mcSession: MCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(LobbyViewController.updateLabel), userInfo: nil, repeats: true)
        
        updateLabel()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateLabel() {
        let newText = "Number of Players: " + String(mcSession.connectedPeers.count + 1)
        theLabel.text = newText
        print("updated label to: \(newText)")
    }
    
    @IBAction func startGame(_ sender: Any) {
        performSegue(withIdentifier: "startCharacterCreation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: CharacterCreationViewController = segue.destination as! CharacterCreationViewController
        if segue.identifier == "startCharacterCreation" {
            destVC.mcSession = mcSession
            timer.invalidate()
            
        }
    }
    
}

