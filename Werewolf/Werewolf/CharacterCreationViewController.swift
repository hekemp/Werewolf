//
//  CharacterCreationViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/25/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit

class CharacterCreationViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var ageField: UITextField?
    @IBOutlet weak var genderField: UITextField?
    @IBOutlet weak var occupationField: UITextField?
    @IBAction func doRandomCharacterCreation(_ sender: Any) {
        let name = "randomName"
        let age = "randomAge"
        let gender = "randomGender"
        let occupation = "randomOccupation"
        let role = "testrole"
        GameSession.active?.myCharacter = PlayerCharacter(name: name, age: age, gender: gender, occupation: occupation, role: role)

    }
    @IBAction func doManualCharacterCreation(_ sender: Any) {
        let name = nameField?.text
        let age = ageField?.text
        let gender = genderField?.text
        let occupation = occupationField?.text
        let role = "testrole"
        GameSession.active?.myCharacter = PlayerCharacter(name: name!, age: age!, gender: gender!, occupation: occupation!, role: role)
        
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
