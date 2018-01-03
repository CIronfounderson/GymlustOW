//
//  Score.swift
//  Gymlust
//
//  Created by Eric de Haan on 22-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import Foundation

struct Score {
    var eScore:Float = 0.0
    var dScore:Float = 0.0
    var nScore:Float = 0.0
    var total:Float = 0.0
    
    init(scoreE:Float, scoreD:Float, scoreN:Float) {
        eScore = scoreE
        dScore = scoreD
        nScore = scoreN
        total = dScore + eScore - nScore
    }
}
