//
//  Character .swift
//  TwoPlayersFight
//
//  Created by MacBook Retina i7  on 04/04/16.
//  Copyright © 2016 marty.k7. All rights reserved.
//

import Foundation

class Character {
    
    private var _hp: Int = 100
    private var _attckPwr: Int = 10
    private var _name = "Player"

    
    var hp: Int {
        get { return _hp }
    }
    var attckPwr: Int {
        get { return _attckPwr }
     }
    var name: String {
        get { return _name }
    }
    var isAlive: Bool {
        if hp <= 0 {
            return false
        } else {
            return true
        }
    }
    init(name: String, startingHp: Int, attckPwr: Int) {
        self._name = name
        self._hp = startingHp
        self._attckPwr = attckPwr
    }
    func atemptAttack(attckPwr: Int) -> Bool {
        self._hp -= attckPwr
        return true
    }
}