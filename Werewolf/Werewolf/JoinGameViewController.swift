//
//  JoinGameViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
class JoinGameViewController: UIViewController {
    
    @IBOutlet weak var roomCode: UITextField!
    @IBAction func gameWasJoined(_ sender: Any) {
        let _ = GameSession(roomToJoin: Int(roomCode.text!)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
