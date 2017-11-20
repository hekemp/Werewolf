//
//  CharacterViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/25/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit

class CharacterViewController: UIViewController {
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterAge: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var characterOccupation: UILabel!
    @IBOutlet weak var characterRole: UILabel!
    
    //
    
    override func viewWillAppear(_ animated: Bool) {
        let character = GameSession.active.myCharacter
        characterName.text = character?.name
        characterAge.text = character?.age
        characterGender.text = character?.gender
        characterOccupation.text = character?.occupation
        characterRole.text = character?.role
        
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
