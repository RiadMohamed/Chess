//
//  Knight.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class Knight: UIChessPiece {
    init(frame: CGRect, color: UIColor, vc: ViewController) {
        super.init(frame: frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            self.text = "♞"
        } else {
			let myAttribute: [NSAttributedString.Key : Any] = [ .strokeColor : UIColor.black, .strokeWidth : -2.0 ]
			let tempString = NSAttributedString(string: "♘", attributes: myAttribute)
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
        let validMoves = [(source.row-1, source.col+2), (source.row-2, source.col+1), (source.row-2, source.col-1), (source.row-1, source.col-2), (source.row+1, source.col-2), (source.row+2, source.col-1), (source.row+2, source.col+1), (source.row+1, source.col+2)]
        
        for (validRow, validCol) in validMoves {
            if dest.row == validRow && dest.col == validCol {
                return true
            }
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
