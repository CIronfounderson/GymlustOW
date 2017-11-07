//
//  Match.swift
//  Gymlust
//
//  Created by Eric de Haan on 22-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import Foundation

class Match:Equatable {
    
    var name = ""
    var order = "000"
    var participants = [Participant]()
    
    static func ==(lhs:Match, rhs:Match) -> Bool { // Implement Equatable
        return lhs.name == rhs.name
    }
    
    func rearrange(order:SortOrder) {
        if order == SortOrder.StartingOrder {
            participants = participants.sorted(by: {$0.startSequence < $1.startSequence})
        } else if order == SortOrder.ResultsOrder {
            participants = participants.sorted(by: {$0.score > $1.score})
        }
    }
}
