//
//  User.swift
//  Gymlust
//
//  Created by Eric de Haan on 27-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import Foundation

class AppUser {
    var isAdmin = false
    var isBeamReferee = false
    var isPonyReferee = false
    var isFloorReferee = false
    var isVaultReferee = false
    
    func isReferee() -> Bool {
        return isBeamReferee || isPonyReferee || isVaultReferee || isFloorReferee
    }
}
