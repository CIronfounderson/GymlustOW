//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
// email: app@gymlustschoorl.nl
// password: WW$Gymlust
// username: AppUser
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

@objc(SignInViewController)
class SigninViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    var ref: DatabaseReference!
    var eventCode = ""
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor.white.cgColor
        
//        createButton.layer.cornerRadius = 5
//        createButton.layer.borderWidth = 2
//        createButton.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapEmailLogin(_:)))
        self.signInButton.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
//            self.showEventSelection()
            self.performSegue(withIdentifier: "sgSelectEvent", sender: nil)
//            self.performSegue(withIdentifier: "sgFill", sender: nil)
        }
        ref = Database.database().reference()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Saves user profile information to user database
    func saveUserInfo(_ user: User, withUsername username: String) {
        
        // Create a change request
//        self.showSpinner {}
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            
//            self.hideSpinner {}
            
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            
            // [START basic_write]
            self.ref.child("users").child(user.uid).setValue(["username": username])
            // [END basic_write]
            self.performSegue(withIdentifier: "sgSelectEvent", sender: nil)
        }
        
    }
    
    @objc func didTapEmailLogin(_ sender: AnyObject) {
        
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            self.showMessagePrompt("email/password can't be empty")
            return
        }
        
//        self.showSpinner {}
        
        // Sign user in
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
//            self.hideSpinner {}
            
            guard let user = user, error == nil else {
                self.showMessagePrompt(error!.localizedDescription)
                return
            }
            
            self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Check if user already exists
                guard !snapshot.exists() else {
                    self.performSegue(withIdentifier: "sgSelectEvent", sender: nil)
//                    self.showEventSelection()
                    return
                }
                
                // Otherwise, create the new user account
                self.showTextInputPrompt(withMessage: "Username:") { (userPressedOK, username) in
                    
                    guard let username = username else {
                        self.showMessagePrompt("Username can't be empty")
                        return
                    }
                    
                    self.saveUserInfo(user, withUsername: username)
                }
            }) // End of observeSingleEvent
        }) // End of signIn
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        
        func getEmail(completion: @escaping (String) -> ()) {
            self.showTextInputPrompt(withMessage: "Email:") { (userPressedOK, email) in
                guard let email = email else {
                    self.showMessagePrompt("Email can't be empty.")
                    return
                }
                completion(email)
            }
        }
        
        func getUsername(completion: @escaping (String) -> ()) {
            self.showTextInputPrompt(withMessage: "Username:") { (userPressedOK, username) in
                guard let username = username else {
                    self.showMessagePrompt("Username can't be empty.")
                    return
                }
                completion(username)
            }
        }
        
        func getPassword(completion: @escaping (String) -> ()) {
            
            self.showTextInputPrompt(withMessage: "Password:") { (userPressedOK, password) in
                guard let password = password else {
                    self.showMessagePrompt("Password can't be empty.")
                    return
                }
                completion(password)
            }
        }
        
        // Get the credentials of hte user
        getEmail { email in
            getUsername { username in
                getPassword { password in
                    
                    // Create the user with the provided credentials
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        guard let user = user, error == nil else {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                        
                        // Finally, save their profile
                        self.saveUserInfo(user, withUsername: username)
                        
                    })
                }
            }
        }
        
    }
    
//    func showEventSelection() {
//        let vc:SelectEventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectEvent") as! SelectEventViewController
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
//    }
    
    // MARK: - UITextFieldDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapEmailLogin(textField)
        return true
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sgShowEvent" {
//            let vc:TournamentViewController = segue.destination as! TournamentViewController
//            vc.tournamentName = eventCode
//        }
//    }
}

//extension SigninViewController:SelectEventDelegate {
//    func didSelectEvent(sender: SelectEventViewController, eventCode: String) {
//        sender.dismiss(animated: true, completion: nil)
//        self.eventCode = eventCode
//        self.performSegue(withIdentifier: "sgShowEvent", sender: self)
//    }
//
//
//}

