//
//  NightSummaryViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 10/29/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class NightSummaryViewController: UIViewController {
    
    var humansAlive = 0
    var werewolvesAlive = 0
    
    var mcSession: MCSession!
    
    var villageList = [[String]]()
    
    var resultList = [String]()
    
    var killed = [String]()
    
    var playerLives = false
    
    @IBOutlet weak var summaryText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameSession.active.voteList = []
        GameSession.active.werewolfVoteList = []
        GameSession.active.seerVoteList = []
        GameSession.active.doctorVoteList = []
        GameSession.active.potionVoteList = []
        GameSession.active.poisonVoteList = []
        GameSession.active.killedList = []
   
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "NighttimeBackground.png")
        
        imageViewBackground.alpha = 0.3
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        
        var werewolfResult = Int (resultList[0])
        var doctorResult = Int (resultList[1])
        var potionResult = Int (resultList[2])
        var poisonResult = Int (resultList[3])
        
        if (werewolfResult != -1){
            if (werewolfResult == doctorResult){
                // Pass
            }
            else if (werewolfResult == potionResult){
                // Pass
            }
            else{
                killed.append(GameSession.active.villageList!.remove(at: werewolfResult!)[0])
            }
        }
        
        if (poisonResult != -1){
            if (poisonResult == doctorResult){
                // Pass
            }
            else if (poisonResult == potionResult){
                // Pass
            }
            else{
                if (werewolfResult == poisonResult){
                    // Pass,  they are already dead
                }
                else if (werewolfResult! < poisonResult! ){ // werewolfResult was before poisonResult so the list has moved down
                    if(werewolfResult == -1){
                        killed.append(GameSession.active.villageList!.remove(at: poisonResult!)[0]) // werewolf didnt' kill
                    }
                    else{
                    killed.append(GameSession.active.villageList!.remove(at: poisonResult! - 1)[0])
                    }
                }
                else { // we know poison result was less than werewolfResult and was not affected
                    killed.append(GameSession.active.villageList!.remove(at: poisonResult!)[0])
                }
                
            }
        }
        
        if (killed.isEmpty){
            summaryText.text = "No One Killed"
        }
        else if (killed.count == 1){
            summaryText.text = "Killed: " + killed[0]
        }
        else{ // we know it's 2
            summaryText.text = "Killed: " + killed[0] + " and " + killed[1]
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkStatus(){

        for player in GameSession.active.villageList! {
            if player[0] == GameSession.active.myCharacter!.name{
                playerLives = true
            }
            if player[1] == "Werewolf"{
                werewolvesAlive = werewolvesAlive + 1
            }
            else{
                humansAlive = humansAlive + 1
            }
        }
        
    }
    
    @objc func timeToMoveOn() {
        
        checkStatus()
        
        print("Player lives: " + String(playerLives))
        
        if(humansAlive <= werewolvesAlive){
            Networking.shared.sendText("werewolf," + String(self.villageList.count), prefixCode: "Gameover")
            self.performSegue(withIdentifier: "goToVillagerGameOver", sender: self)
        }
        else if(werewolvesAlive == 0){
            Networking.shared.sendText("villager," + String(self.villageList.count), prefixCode: "Gameover")
            self.performSegue(withIdentifier: "goToWerewolfGameOver", sender: self)
        }
        else if (!playerLives){
            print("I'm dead!")
            self.performSegue(withIdentifier: "toDead", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "restartDay", sender: self)
        }
        
    }
    
    
}
