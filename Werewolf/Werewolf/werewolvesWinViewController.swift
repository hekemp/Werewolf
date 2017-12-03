//
//  werewolvesWinViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/20/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class werewolvesWinViewController: UIViewController {
    
    @IBOutlet weak var summaryText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "WerwolfWinBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        // Do any additional setup after loading the view, typically from a nib.
        let villageList = GameSession.active.villageList
        let mcSession = GameSession.active.mySession
        print(mcSession!.connectedPeers.count)
        print(villageList!.count)
        let dead = mcSession!.connectedPeers.count + 1 - villageList!.count
        
       // if let numAlive = GameSession.active.gameSurvivors {
        //    summaryText.text = "Alive: " + numAlive
        //} else {
        //    summaryText.text = "Alive: " + String(villageList!.count)
        //}
        
        summaryText.text = ""

        mcSession!.disconnect()
        GameSession.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
