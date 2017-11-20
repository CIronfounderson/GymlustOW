//
//  ParticipantViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 23-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ParticipantViewController: UIViewController {
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblNivo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVaultScore: UILabel!
    @IBOutlet weak var lblPonyScore: UILabel!
    @IBOutlet weak var lblBeamScore: UILabel!
    @IBOutlet weak var lblFloorScore: UILabel!
    @IBOutlet weak var lblTotalScore: UILabel!

    @IBOutlet weak var btnLock: UIButton!
    @IBOutlet weak var lblVault1d: UILabel!
    @IBOutlet weak var lblVault1e: UILabel!
    @IBOutlet weak var lblVault1n: UILabel!
    @IBOutlet weak var vault1nLabel: UILabel!
    @IBOutlet weak var lblVault2d: UILabel!
    @IBOutlet weak var lblVault2e: UILabel!
    @IBOutlet weak var lblVault2n: UILabel!
    @IBOutlet weak var vault2nLabel: UILabel!

    @IBOutlet weak var lblPonyd: UILabel!
    @IBOutlet weak var lblPonye: UILabel!
    @IBOutlet weak var lblPonyn: UILabel!
    @IBOutlet weak var ponynLabel: UILabel!
    
    @IBOutlet weak var lblBeamd: UILabel!
    @IBOutlet weak var lblBeame: UILabel!
    @IBOutlet weak var lblBeamn: UILabel!
    @IBOutlet weak var beamnLabel: UILabel!
    
    @IBOutlet weak var lblFloord: UILabel!
    @IBOutlet weak var lblFloore: UILabel!
    @IBOutlet weak var lblFloorn: UILabel!
    @IBOutlet weak var floornLabel: UILabel!
    
    var participantID = ""
    var databaseRef: DatabaseReference!
    var tournamentName = "ow2017"
    var participant = Participant()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.vwContent.layer.cornerRadius = 8
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        // Get a reference to the database service
        databaseRef = Database.database().reference()
        getData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

    func getData() {
        let dbIdentifier = "\(tournamentName)/\(participantID)"
        databaseRef.child(dbIdentifier).observe(.value, with: { (snapshot) in
            self.participant.FillData(key: snapshot.key, participantDict: snapshot.value as! NSDictionary)
            self.showData()
        })
    }
    
    func showData() {
        self.btnLock.isEnabled = self.participant.status == ParticipantStatus.Locked
        
        self.lblName.text = self.participant.name
        self.lblNivo.text = self.participant.level
        
        self.lblVault1n.isHidden = self.participant.vault1Score.nScore==0
        self.vault1nLabel.isHidden = self.participant.vault1Score.nScore==0
        self.lblVault1d.text = String(format:"%.3f", self.participant.vault1Score.dScore)
        self.lblVault1e.text = String(format:"%.3f", self.participant.vault1Score.eScore)
        self.lblVault1n.text = String(format:"%.3f", self.participant.vault1Score.nScore)

        self.lblVault2n.isHidden = self.participant.vault2Score.nScore==0
        self.vault2nLabel.isHidden = self.participant.vault2Score.nScore==0
        self.lblVault2d.text = String(format:"%.3f", self.participant.vault2Score.dScore)
        self.lblVault2e.text = String(format:"%.3f", self.participant.vault2Score.eScore)
        self.lblVault2n.text = String(format:"%.3f", self.participant.vault2Score.nScore)
        self.lblVaultScore.text = String(format:"%.3f", (self.participant.vault1Score.total + self.participant.vault2Score.total)/2)
        
        self.lblPonyn.isHidden = self.participant.ponyScore.nScore==0
        self.ponynLabel.isHidden = self.participant.ponyScore.nScore==0
        self.lblPonyd.text = String(format:"%.3f", self.participant.ponyScore.dScore)
        self.lblPonye.text = String(format:"%.3f", self.participant.ponyScore.eScore)
        self.lblPonyn.text = String(format:"%.3f", self.participant.ponyScore.nScore)
        self.lblPonyScore.text = String(format:"%.3f", self.participant.ponyScore.total)
        
        self.lblBeamn.isHidden = self.participant.beamScore.nScore==0
        self.beamnLabel.isHidden = self.participant.beamScore.nScore==0
        self.lblBeamd.text = String(format:"%.3f", self.participant.beamScore.dScore)
        self.lblBeame.text = String(format:"%.3f", self.participant.beamScore.eScore)
        self.lblBeamn.text = String(format:"%.3f", self.participant.beamScore.nScore)
        self.lblBeamScore.text = String(format:"%.3f", self.participant.beamScore.total)
        
        self.lblFloorn.isHidden = self.participant.floorScore.nScore==0
        self.floornLabel.isHidden = self.participant.floorScore.nScore==0
        self.lblFloord.text = String(format:"%.3f", self.participant.floorScore.dScore)
        self.lblFloore.text = String(format:"%.3f", self.participant.floorScore.eScore)
        self.lblFloorn.text = String(format:"%.3f", self.participant.floorScore.nScore)
        self.lblFloorScore.text = String(format:"%.3f", self.participant.floorScore.total)
        
        self.lblTotalScore.text = String(format:"%.3f", self.participant.score)
    }
}
