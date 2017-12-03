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
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "DaytimeBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
