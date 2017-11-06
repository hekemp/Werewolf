//
//  RoomCodeViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class RoomCodeViewController: UIViewController {
    
    
    @IBAction func willCreateRoom(_ sender: Any) {
        let createRoomConfirmation = UIAlertAction(title: "Create Game Room?", style: UIAlertActionStyle.default)
        startHosting(action: createRoomConfirmation)
        performSegue(withIdentifier: "connected", sender: self)
    }
    @IBOutlet weak var roomCodeLabel: UILabel!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let session = GameSession()
        roomCodeLabel?.text = session.roomCodeDisplay()
    }
    func startHosting(action: UIAlertAction) {
        if let mcSession = GameSession.active?.mcSession, let serviceType = GameSession.active?.serviceType!{
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        }
    }
}
