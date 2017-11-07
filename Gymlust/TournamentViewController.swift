//
//  TournamentViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 22-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SectionHeader: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class ParticipantCell: UITableViewCell {
    @IBOutlet weak var imgLight: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalScore: UILabel!
}

class TournamentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Put this in your FirstViewController
    @IBAction func returnFromRefereeViewController(segue:UIStoryboardSegue) {
        print("This is called after  modal is dismissed by menu button on Siri Remote")
        checkIfReferee()
    }
    
    @IBOutlet weak var btnReferee: UIButton!
    @IBOutlet weak var refereeLoginButton: UIImageView!
    @IBOutlet weak var resultsButton: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    var selectedParticipantId = ""
    var databaseRef: DatabaseReference!
    var tournamentName = "ow2017"
    var tournament = Tournament()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginTap = UITapGestureRecognizer.init(target: self, action: #selector(refereeLogin))
        loginTap.numberOfTapsRequired = 1
        self.refereeLoginButton.addGestureRecognizer(loginTap)
        
        let trophyTap = UITapGestureRecognizer.init(target:self, action: #selector(gotoResults))
        trophyTap.numberOfTapsRequired = 1
        self.resultsButton.addGestureRecognizer(trophyTap)
        
        // Get a reference to the database service
        databaseRef = Database.database().reference()
        
        btnReferee.layer.borderColor = UIColor.white.cgColor
        btnReferee.layer.borderWidth = 1
        btnReferee.layer.cornerRadius = 5 // btnReferee.frame.size.height / 2
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfReferee()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tournament.matches.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("nrOfRowsInSection: \(tournament.matches[section].participants.count)")
        return tournament.matches[section].participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
        
        if (indexPath.row % 2) == 0 {
            cell.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        }

        cell.imgLight.isHidden = !(tournament.matches[indexPath.section].participants[indexPath.row].status==ParticipantStatus.Locked)
        cell.name.text = tournament.matches[indexPath.section].participants[indexPath.row].name
        cell.totalScore.text = String(format: "%.3f", tournament.matches[indexPath.section].participants[indexPath.row].score)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! SectionHeader

        headerView.titleLabel.text = self.tournament.matches[section].name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedParticipantId = tournament.matches[indexPath.section].participants[indexPath.row].id
        
        if appDelegate.currentUser.isReferee() && tournament.matches[indexPath.section].participants[indexPath.row].status==ParticipantStatus.Free {
            self.performSegue(withIdentifier: "sgEditScore", sender: nil)
        } else {
            self.performSegue(withIdentifier: "sgParticipantDetail", sender: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="sgParticipantDetail") {
            let vc = segue.destination as! ParticipantViewController
            vc.participantID = selectedParticipantId
        }
        if(segue.identifier=="sgEditScore") {
            let vc = segue.destination as! EditScoreViewController
            vc.participantID = selectedParticipantId
        }
//        if(segue.identifier=="sgResults") {
//            let vc = segue.destination as! ResultsViewController
//        }
    }
    
    func getData() {
        print("GetData")
        databaseRef.child(tournamentName).queryOrdered(byChild: "startPosition").observe(.value, with: { (snapshot) in
            if let participantsDict = snapshot.value as? [String:AnyObject]{
                self.tournament = Tournament()
                for participantObj in participantsDict {
                    let participantDict = participantObj.value as! NSDictionary
                    let matchName = participantDict["nivo"] as! String
                    let matchIndex = self.tournament.getMatchIndexForMatch(matchName: matchName)
                    self.tournament.matches[matchIndex].order = String((participantDict["startSequence"] as! String).prefix(3))
                    let match = self.tournament.matches[matchIndex]
                    
                    let participant = Participant()
                    participant.FillData(key: participantObj.key, participantDict: participantDict)
                    
                    match.participants.append(participant)
                }
                self.tournament.rearrange(order: SortOrder.StartingOrder)
                
                self.tableview.reloadData()
                
            }

        })

    }
    
    @objc func gotoResults() {
        self.performSegue(withIdentifier: "sgResults", sender: self)
    }
    
    @objc func refereeLogin() {
        self.performSegue(withIdentifier: "sgRefereeLogin", sender: self)
    }
    
    func checkIfReferee() {
        var image = UIImage()
        
        if appDelegate.currentUser.isReferee() {
            if appDelegate.currentUser.isFloorReferee {
                image = UIImage.init(named: "floor.png")!
            }
            if appDelegate.currentUser.isBeamReferee {
                image = UIImage.init(named: "beam.png")!
            }
            if appDelegate.currentUser.isPonyReferee {
                image = UIImage.init(named: "unevenbars.png")!
            }
            if appDelegate.currentUser.isVaultReferee {
                image = UIImage.init(named: "vault.png")!
            }
            btnReferee.setImage(image, for: .normal)
            btnReferee.isHidden = false
        } else {
            btnReferee.isHidden = true
        }

    }
}
