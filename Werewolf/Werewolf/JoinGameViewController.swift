//
//  JoinGameViewController.swift
//  Werewolf
//
//  Created by macbook_user on 10/23/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
class JoinGameViewController: UIViewController, UITextFieldDelegate, MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    

    
    @IBOutlet weak var roomCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.roomCode.delegate = self
    }
    
    @IBAction func gameWasJoined(_ sender: Any) {
        if let roomCodeInt = Int(roomCode.text!){
            let _ = GameSession(roomToJoin: roomCodeInt)
            let joinGameConfirmation = UIAlertAction(title: "Join room #\(roomCode.text!)", style: UIAlertActionStyle.default)
            joinSession(action: joinGameConfirmation)
            performSegue(withIdentifier: "connected", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Room number must be a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits //for digits only
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func joinSession(action: UIAlertAction) {
        if let serviceType = GameSession.active?.serviceType, let mcSession = GameSession.active?.mcSession{
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        }
    }
    
}
