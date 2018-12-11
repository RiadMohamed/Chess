//
//  ChessGame.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class ChessGame: NSObject {
    
    var theChessBoard: ChessBoard!
    
    func isMoveValid(piece: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool
    {
        return true
    }
    
    func move(piece chessPieceToMove: UIChessPiece, fromIndex sourceIndex:  BoardIndex, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint) {
        
        // get initial chess piece frame
        let initialPieceFrame = chessPieceToMove.frame
        
        // remove piece at destination
        let pieceToRemove = theChessBoard.board[destIndex.row][destIndex.col]
        theChessBoard.remove(piece: pieceToRemove)
        
        // place the chess piece at destination
        theChessBoard.place(chessPiece: chessPieceToMove, toIndex: destIndex, toOrigin: destOrigin)
        
        // put a dummy piece in the vacant source tile
        theChessBoard.board[sourceIndex.row][sourceIndex.col] = Dummy(frame: initialPieceFrame)
    }
    
    init(viewController: ViewController){
        theChessBoard = ChessBoard.init(viewController: viewController)
    }
}
