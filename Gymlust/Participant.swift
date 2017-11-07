//
//  Participant.swift
//  Gymlust
//
//  Created by Eric de Haan on 22-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum ParticipantStatus { case Free
                         case Locked
}

enum SortOrder { case StartingOrder
                case ResultsOrder
}

class Participant:NSObject {
    var id = ""
    var name = ""
    var level = ""
    var beamScore = Score(scoreE: 0, scoreD: 0, scoreN: 0)
    var floorScore = Score(scoreE: 0, scoreD: 0, scoreN: 0)
    var vault1Score = Score(scoreE: 0, scoreD: 0, scoreN: 0)
    var vault2Score = Score(scoreE: 0, scoreD: 0, scoreN: 0)
    var ponyScore = Score(scoreE: 0, scoreD: 0, scoreN: 0)
    var score:Float = 0.0
    var startPosition:Int = 0
    var status:ParticipantStatus = ParticipantStatus.Free
    var isChampion = false
    var place:Int = 0
    var resultSequence = "10100000" // [1|2]<00 - 99><00000-score>
    var startSequence = "10101"
    
    func FillData(key:String, participantDict:NSDictionary) {
        
        id = key
        name = participantDict["name"] as! String
        level = participantDict["nivo"] as! String
//        startPosition = participantDict["start"] as! Int
        startSequence = participantDict["startSequence"] as! String
        resultSequence = participantDict["resultSequence"] as! String

        place = 0
        
        beamScore = Score(scoreE: (participantDict["beamE"] as! NSNumber).floatValue,
                                           scoreD: (participantDict["beamD"] as! NSNumber).floatValue,
                                           scoreN: (participantDict["beamN"] as! NSNumber).floatValue)
        
        floorScore = Score(scoreE: (participantDict["floorE"] as! NSNumber).floatValue,
                                            scoreD: (participantDict["floorD"] as! NSNumber).floatValue,
                                            scoreN: (participantDict["floorN"] as! NSNumber).floatValue )
        
        vault1Score = Score(scoreE: (participantDict["vault1E"] as! NSNumber).floatValue,
                                             scoreD: (participantDict["vault1D"] as! NSNumber).floatValue,
                                             scoreN: (participantDict["vault1N"] as! NSNumber).floatValue)
        
        vault2Score = Score(scoreE: (participantDict["vault2E"] as! NSNumber).floatValue,
                                             scoreD: (participantDict["vault2D"] as! NSNumber).floatValue,
                                             scoreN: (participantDict["vault2N"] as! NSNumber).floatValue)
        
        ponyScore = Score(scoreE: (participantDict["ponyE"] as! NSNumber).floatValue,
                                           scoreD: (participantDict["ponyD"] as! NSNumber).floatValue,
                                           scoreN: (participantDict["ponyN"] as! NSNumber).floatValue)
        
        score = beamScore.total + floorScore.total + (vault1Score.total + vault2Score.total)/2 + ponyScore.total
        let statusString = participantDict["status"] as! String
        if statusString == "locked" {
            status = ParticipantStatus.Locked
        }
        if statusString == "free" {
            status = ParticipantStatus.Free
        }
    }
    
    func WriteToDatabase(databaseRef:DatabaseReference, tournament:String) {
        var statusString = ""
        switch(status) {
        case ParticipantStatus.Free:
            statusString = "free"
            break
        case ParticipantStatus.Locked:
            statusString = "locked"
            break
        }
        databaseRef.child(tournament).child(id).setValue(["nivo":level,
                                                          "name":name,
                                                          "start":startPosition,
                                                          "beamD":beamScore.dScore,
                                                          "beamE":beamScore.eScore,
                                                          "beamN":beamScore.nScore,
                                                          "vault1D":vault1Score.dScore,
                                                          "vault1E":vault1Score.eScore,
                                                          "vault1N":vault1Score.nScore,
                                                          "vault2D":vault2Score.dScore,
                                                          "vault2E":vault2Score.eScore,
                                                          "vault2N":vault2Score.nScore,
                                                          "floorD":floorScore.dScore,
                                                          "floorE":floorScore.eScore,
                                                          "floorN":floorScore.nScore,
                                                          "ponyD":ponyScore.dScore,
                                                          "ponyE":ponyScore.eScore,
                                                          "ponyN":ponyScore.nScore,
                                                          "startSequence":startSequence,
                                                          "resultSequence":resultSequence,
                                                          "status": statusString])
    }
}
