//
//  Tournament.swift
//  Gymlust
//
//  Created by Eric de Haan on 22-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import Foundation

class Tournament:NSObject {
    
    var name:String
    var matches:[Match]

    override init() {
        name = ""
        matches = [Match]()
    }
    
    func getMatchIndexForMatch(matchName:String) -> Int {
        let searchMatch = Match()
        searchMatch.name = matchName
        if(!matches.contains(searchMatch)) {
            matches.append(searchMatch)
        }
        return matches.index(of: searchMatch)!
    }
    
    func rearrange(order:SortOrder) {
        matches = matches.sorted(by: { $0.order < $1.order })
        for match in matches {
            match.rearrange(order: order)
        }
    }
    
    func fillChampion() {
        setChampion(championId: getParticipantIdOfChampion(level: "1"), level: "1")
        setChampion(championId: getParticipantIdOfChampion(level: "2"), level: "2")
    }
    
    func getParticipantIdOfChampion(level:String) -> String {
        var championId = ""
        var championScore:Float = 0.0
        for match in matches {
            for participant in match.participants {
                if participant.startSequence.prefix(1) == level {
                    if participant.score > championScore {
                        championScore = participant.score
                        championId = participant.id
                    }
                }
            }
        }
        return championId
    }
    
    func setChampion(championId:String, level:String) {
        if championId != "" {
            for match in matches {
                if(match.order.prefix(1) == level) {
                    for participant in match.participants {
                        participant.isChampion = (participant.id == championId)
                    }
                }
            }
        }
    }
}
