//
//  RoleRulesReviewViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit

class RoleRulesReviewViewController: UIViewController {
    let roleRules : [String: String] = [
        "Villager": "The most commonplace role, a simple Villager, spends the game trying to root out who they believe the werewolves (and other villagers) are. While they do not need to lie, the role requires players to keenly sense and point out the flaws or mistakes of their fellow players. Someone is speaking too much? Could mean they're a werewolf. Someone isn't speaking enough? Could mean the same thing. It all depends on the people you're playing with, and how well you know them.",
        "Doctor": "Also a villager, the Doctor has the ability to heal themselves or another villager during the night. Should they heal themselves, they will be safe from being killed by the werewolves, or should they want to prove themselves the Doctor or fear the death of a fellow villager, can opt to heal them instead. Again, the strategy here is up to you",
        "Werewolf": "The goal of the werewolves is to decide together on one villager to secretly kill off during the night, while posing as villagers during the day so they're not killed off themselves. One by one they'll kill off villagers and win when there are either the same number of villagers and werewolves left, or all the villagers have died. This role is the hardest of all to maintain, because these players are lying for the duration of the entire game",
        "Seer": "The Seer, while first and foremost a villager, has the added ability to \"see\" who the werewolves are once night falls. The Seer can select any of their fellow players and will be told yes or no as to whether or not they are the werewolf. The Seer can then choose to keep this information a secret during the day, or reveal themselves as the Seer and use the knowlege they gained during the night in their defense or to their advantage during the day. The strategy here is up to you",
        "Witch": "This role, while first and foremost taking on all the elements of a regular villager throughout the game, also has the additional powers of one potion, which will bring someone back to life, and one poison, which will kill someone, which they may use at any point throughout the game. While the Witch can only use their potion and poison once, each action must be said each night to maintain anonymity as to what has been done. They can only use one per night until both are gone, and have the ability to save them until a point in the game they deem fit."
    ]
    @IBOutlet weak var roleName: UILabel!
    @IBOutlet weak var roleExplaination: UILabel!
    @IBOutlet weak var pageBar: UIPageControl!
    var roles: [String]!
    @IBAction func pageSwitched(_ sender: Any) {
        setPage()
    }
    func setPage(){
        let currentRole = roles[pageBar.currentPage]
        let currentRoleText = roleRules[currentRole]
        roleName.text = currentRole
        roleExplaination.text = currentRoleText
    }
    @IBAction func leftSwipeReceived(_ sender: UISwipeGestureRecognizer) {
        if(pageBar.currentPage+1<=pageBar.numberOfPages){
            pageBar.currentPage += 1
            setPage()
        }
    }
    @IBAction func rightSwipeReceived(_ sender: Any) {
        if(pageBar.currentPage>0){
            pageBar.currentPage -= 1
            setPage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RoleRulesReviewViewController.rightSwipeReceived(_:)))
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RoleRulesReviewViewController.leftSwipeReceived(_:)))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        roles = GameSession.active?.activeRoles
        pageBar.numberOfPages = roles.count
        setPage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
