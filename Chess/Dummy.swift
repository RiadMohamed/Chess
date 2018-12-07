//
//  Dummy.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class Dummy: Piece {
    private var xStroage: CGFloat!
    private var yStorage: CGFloat!
    
    var x: CGFloat {
        get {
            return self.xStroage
        }
        set {
            self.xStroage = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.yStorage
        }
        set {
            self.yStorage = newValue
        }
    }
    
    init(frame: CGRect) {
        self.xStroage = frame.origin.x
        self.yStorage = frame.origin.y
    }
    
    init() {
    }
    
}
