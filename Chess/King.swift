//
//  King.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class King: UIChessPiece {
    init(frame: CGRect, color: UIColor, vc: ViewController) {
        super.init(frame: frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            self.text = "♚"
        } else {
			let myAttribute: [NSAttributedString.Key : Any] = [ .strokeColor : UIColor.black, .strokeWidth : -2.0 ]
			let tempString = NSAttributedString(string: "♔", attributes: myAttribute)
			self.attributedText = tempString
        }
        
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        vc.chessPieces.append(self)
        vc.view.addSubview(self)
    }
    
    
    func doesMoveSeemFine(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        let differenceInRows = abs(dest.row - source.row)
        let differenceInCols = abs(dest.col - source.col)
		if case 0...1 = differenceInRows {
			if case 0...1 = differenceInRows {
				return true
			}
		}
		return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
