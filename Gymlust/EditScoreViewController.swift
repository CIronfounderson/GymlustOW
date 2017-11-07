//
//  EditScoreViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 30-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditScoreViewController: UIViewController {

    @IBOutlet weak var lblNivo: UILabel!
    @IBOutlet weak var toestelImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func vaultChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex==0 {
            getVaultFormData(vaultNr: 2)
        } else {
            getVaultFormData(vaultNr: 1)
        }
        showData()
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        if appDelegate.currentUser.isVaultReferee {
            if segmentedControl.selectedSegmentIndex==0 {
                getVaultFormData(vaultNr: 1)
            } else {
                getVaultFormData(vaultNr: 2)
            }
        } else {
            getFormData()
        }
        goBack()
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        goBack()
    }
    
    @IBOutlet weak var dscoreLabel: UILabel!
    @IBOutlet weak var dscorePoint: UIStepper!
    @IBOutlet weak var dscoreTenth: UIStepper!
    @IBAction func dscorePointChanged(_ sender: Any) {
        showScore(stepper1: dscorePoint, stepper2: dscoreTenth, label: dscoreLabel)
    }
    @IBAction func dscoreTenthChanged(_ sender: Any) {
        showScore(stepper1: dscorePoint, stepper2: dscoreTenth, label: dscoreLabel)
    }
    @IBOutlet weak var escoreLabel: UILabel!
    @IBOutlet weak var escorePoint: UIStepper!
    @IBOutlet weak var escoreTenth: UIStepper!
    @IBAction func escorePointChanged(_ sender: Any) {
        showScore(stepper1: escorePoint, stepper2: escoreTenth, label: escoreLabel)
   }
    @IBAction func escoreTenthChanged(_ sender: Any) {
        showScore(stepper1: escorePoint, stepper2: escoreTenth, label: escoreLabel)
    }

    @IBOutlet weak var nscoreLabel: UILabel!
    @IBOutlet weak var nscorePoint: UIStepper!
    @IBOutlet weak var nscoreTenth: UIStepper!
    @IBAction func nscorePointChanged(_ sender: Any) {
        showScore(stepper1: nscorePoint, stepper2: nscoreTenth, label: nscoreLabel)
    }
    @IBAction func nscoreTenthChanged(_ sender: Any) {
        showScore(stepper1: nscorePoint, stepper2: nscoreTenth, label: nscoreLabel)
    }
    
    var participantID = ""
    var databaseRef: DatabaseReference!
    var tournamentName = "ow2017"
    var participant = Participant()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var match = Match()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the database service
        databaseRef = Database.database().reference()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let dbIdentifier = "\(tournamentName)/\(participantID)"
        databaseRef.child(dbIdentifier).observeSingleEvent(of: .value, with: { (snapshot) in
//            self.participant = Participant()
            self.participant.FillData(key: snapshot.key, participantDict: snapshot.value as! NSDictionary)
            if self.participant.status == ParticipantStatus.Free {
                self.showData()
                self.participant.status = ParticipantStatus.Locked
                self.participant.WriteToDatabase(databaseRef: self.databaseRef, tournament: self.tournamentName)
            } else {
                // ShowMessage and leave...
                let alertController = UIAlertController(title: "Oeps", message: "Er is al een jurylid wat de score van \(self.participant.name) aan het invullen is...", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {
                    (action:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    func showData() {
        var scoreObj = Score(scoreE: 0, scoreD: 0, scoreN: 0)
        
        self.lblName.text = self.participant.name
        self.lblNivo.text = self.participant.level
        
        if appDelegate.currentUser.isBeamReferee {
            lblEvent.text = "Balk"
            scoreObj = self.participant.beamScore
            segmentedControl.isHidden = true
        }
        if appDelegate.currentUser.isPonyReferee {
            lblEvent.text = "Brug"
            scoreObj = self.participant.ponyScore
            segmentedControl.isHidden = true
        }
        if appDelegate.currentUser.isFloorReferee {
            lblEvent.text = "Vloer"
            scoreObj = self.participant.floorScore
            segmentedControl.isHidden = true
        }
        if appDelegate.currentUser.isVaultReferee {
            lblEvent.text = "Sprong"
            segmentedControl.isHidden = false
            if segmentedControl.selectedSegmentIndex==0 {
                scoreObj = self.participant.vault1Score
            } else {
                scoreObj = self.participant.vault2Score
            }
        }
        
        // modf returns a 2-element tuple,
        // with the whole number part in the first element,
        // and the fraction part in the second element
        var splitFloat = modf(scoreObj.dScore)
        dscorePoint.value = Double(splitFloat.0) // 3.0
        var decimalPart = round(splitFloat.1 * 100)
        dscoreTenth.value = Double(decimalPart)
        showScore(stepper1: dscorePoint, stepper2: dscoreTenth, label: dscoreLabel)
        
        splitFloat = modf(scoreObj.eScore)
        escorePoint.value = Double(splitFloat.0)
        decimalPart = round(splitFloat.1 * 100)
        escoreTenth.value = Double(decimalPart)
        showScore(stepper1: escorePoint, stepper2: escoreTenth, label: escoreLabel)

        splitFloat = modf(scoreObj.nScore)
        nscorePoint.value = Double(splitFloat.0)
        decimalPart = round(splitFloat.1 * 100)
        nscoreTenth.value = Double(decimalPart)
        showScore(stepper1: nscorePoint, stepper2: nscoreTenth, label: nscoreLabel)
        
    }
    
    func getFormData() {
        let escoreValue = Float(escorePoint.value + escoreTenth.value/100)
        let dscoreValue = Float(dscorePoint.value + dscoreTenth.value/100)
        let nscoreValue = Float(nscorePoint.value + nscoreTenth.value/100)
        
        let scoreObj = Score(scoreE: escoreValue, scoreD: dscoreValue, scoreN: nscoreValue)
        if appDelegate.currentUser.isBeamReferee {
            self.participant.beamScore = scoreObj
        }
        if appDelegate.currentUser.isPonyReferee {
            self.participant.ponyScore = scoreObj
        }
        if appDelegate.currentUser.isFloorReferee {
            self.participant.floorScore = scoreObj
        }

    }
    
    func getVaultFormData(vaultNr:Int) {
        let escoreValue = Float(escorePoint.value + escoreTenth.value/100)
        let dscoreValue = Float(dscorePoint.value + dscoreTenth.value/100)
        let nscoreValue = Float(nscorePoint.value + nscoreTenth.value/100)
        
        let scoreObj = Score(scoreE: escoreValue, scoreD: dscoreValue, scoreN: nscoreValue)
        if appDelegate.currentUser.isVaultReferee {
            if vaultNr==1 {
                self.participant.vault1Score = scoreObj
            } else {
                self.participant.vault2Score = scoreObj
            }
        }
        
    }
    
    func showScore(stepper1:UIStepper, stepper2:UIStepper, label:UILabel) {
        // modf returns a 2-element tuple,
        // with the whole number part in the first element,
        // and the fraction part in the second element
        let score = stepper1.value + stepper2.value/100
        label.text = String(format: "%.2f",score)
 
    }
    
    func goBack() {
        self.participant.status = ParticipantStatus.Free
        self.participant.score = self.participant.beamScore.total + self.participant.floorScore.total + (self.participant.vault1Score.total + self.participant.vault2Score.total)/2 + self.participant.ponyScore.total
        let sequence = self.participant.resultSequence
        let score:Int = 99999 - Int(floor(self.participant.score * 1000))
        let seq = String(sequence.prefix(3)) + "\(score)"
        self.participant.resultSequence = seq
        self.participant.WriteToDatabase(databaseRef: databaseRef, tournament: tournamentName)
        self.dismiss(animated: true, completion: nil)
    }

}
