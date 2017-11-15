//
//  VillageViewController.swift
//  Werewolf
//
//  Created by Heather Kemp on 11/12/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import MultipeerConnectivity

import UIKit

class VillageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var villageListView: UITableView!
    
    @IBOutlet weak var villageNameDisplay: UILabel!
    var villageList : [[String]] = []
    
    var mcSession: MCSession!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let villageList = GameSession.active?.villageList{
            self.villageList = villageList
        }
        if let mcSession = GameSession.active?.mySession{
            self.mcSession = mcSession
        }
        if(GameSession.active?.villageName == nil){
            GameSession.active?.villageName = RandomGenerators.gen.getRandomVillageName()
        }
        villageNameDisplay.text = GameSession.active?.villageName
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Three required UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return villageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellNum:Int = indexPath.row
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "customcell")! as UITableViewCell
    cell.textLabel!.text = villageList[cellNum][0]
    return cell
    }
    
    // two optional UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    print("did select row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    print("will select row \(indexPath.row)")
    return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(String(describing: segue.identifier))")
        let destVC: NominationViewController = segue.destination as! NominationViewController
        if segue.identifier == "moveToNominations" {
            destVC.mcSession = mcSession
            destVC.villageList = self.villageList
            
        }
        
    }
    

    
}

