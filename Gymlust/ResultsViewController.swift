//
//  ResultsViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 01-10-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ResultsSectionHeader: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class ParticipantResultCell: UITableViewCell {
    @IBOutlet weak var imgTrophy: UIImageView!
    @IBOutlet weak var place:UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalScore: UILabel!
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var databaseRef: DatabaseReference!
    var tournamentName = "ow2017"
    var tournament = Tournament()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var backButon: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.backButon.addGestureRecognizer(tap)
        
        // Get a reference to the database service
        databaseRef = Database.database().reference()
        getData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantResultCell", for: indexPath) as! ParticipantResultCell
        
        if (indexPath.row % 2) == 0 {
            cell.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        }
        
        cell.imgTrophy.isHidden = (tournament.matches[indexPath.section].participants[indexPath.row].isChampion==false)
        cell.place.text = "\(indexPath.row + 1)"
        cell.name.text = tournament.matches[indexPath.section].participants[indexPath.row].name
        cell.totalScore.text = String(format: "%.3f", tournament.matches[indexPath.section].participants[indexPath.row].score)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderResultCell") as! ResultsSectionHeader
        
        headerView.titleLabel.text = self.tournament.matches[section].name
        return headerView
    }
    
    func getData() {
        print("GetData")
        databaseRef.child(tournamentName).queryOrdered(byChild: "resultSequence").observe(.value, with: { (snapshot) in
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
                
                self.tournament.rearrange(order: SortOrder.ResultsOrder)
                self.tournament.fillChampion()
                self.tableview.reloadData()
            }
        })
    }

    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
