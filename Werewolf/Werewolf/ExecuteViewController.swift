//
//  ExecuteViewController.swift
//  Werewolf
//
//  Created by macbook_user on 11/2/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit

class ExecuteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
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
}
