//
//  RefereeViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 27-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RefereeViewController: UIViewController, UITextFieldDelegate {
    let eventTypes = ["sprong", "brug", "balk", "vloer"]
    
    @IBOutlet weak var segEvent: UISegmentedControl!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var codeField: UITextField!
    @IBAction func loginPressed(_ sender: Any) {
        let eventType = eventTypes[self.segEvent.selectedSegmentIndex]
        self.databaseRef.child("referees").observeSingleEvent(of: .value, with: {(snapshot) in
            if let refereesDict = snapshot.value as? [String:AnyObject]{
                if let refereeDict = refereesDict[eventType] as? [String:AnyObject] {
                    if let refereeCode = refereeDict["code"] as? String {
                        if refereeCode == self.codeField.text {
                            self.appDelegate.currentUser.isBeamReferee = eventType == "balk"
                            self.appDelegate.currentUser.isVaultReferee = eventType == "sprong"
                            self.appDelegate.currentUser.isPonyReferee = eventType == "brug"
                            self.appDelegate.currentUser.isFloorReferee = eventType == "vloer"
                        }
                    }
                }
            }
            self.performSegue(withIdentifier: "sgUnwindToParent", sender: nil)
        })
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "sgUnwindToParent", sender: nil)
    }
    
    var databaseRef: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the database service
        databaseRef = Database.database().reference()
        
        self.codeField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sgUnwindToParent") {
            
        }
    }

}
