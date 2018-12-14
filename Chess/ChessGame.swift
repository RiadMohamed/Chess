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
    var isWhiteTurn = true;
    
    func isMoveValid(piece: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool
    {
        
        guard isMoveOnBoard(forPieceFrom: sourceIndex, thatGoesTo: destIndex) else {
            print("Move not on Board")
            return false
        }
        
        guard isTurnColor(sameAsPiece: piece) else {
            print("WRONG TURN")
            return false
        }
        return isNormalMoveValid(forPiece: piece, fromIndex: sourceIndex, toIndex: destIndex)
    }
    
    func isNormalMoveValid(forPiece piece: UIChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        guard source != dest else {
            print("MOVING PIECE ON IT'S CURRENT POSITION")
            return false
        }
        guard !isAttackingAlliedPiece(sourceChessPiece: piece, destIndex: dest) else {
            print("ATTACKING ALLIED PIECE")
            return false
        }
        
        switch piece {
        case is Pawn:
            return isMoveValid(forPawn: piece as! Pawn, fromIndex: source, toIndex: dest)
        case is Rook, is Bishop, is Queen:
            return isMoveValid(forRookBishopQueen: piece, fromIndex: source, toIndex: dest)
        case is Knight:
            return false
        case is King:
            if !(piece as! Knight).doesMoveSeemFine(fromIndex: source, toIndex: dest){
                return false
            }
        default:
            break
        }
        return true
    }
    
    func isMoveValid(forPawn pawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        if !pawn.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
            return false
        }
        return true
    }
    
    func isMoveValid(forRookBishopQueen piece: UIChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        return true
    }
    
    func isMoveValid(forKing king: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        return true
    }
    
    func isAttackingAlliedPiece(sourceChessPiece: UIChessPiece, destIndex: BoardIndex) -> Bool {
        let destPiece: Piece = theChessBoard.board[destIndex.row][destIndex.col]
        guard !(destPiece is Dummy) else {
            return false
        }
        let destChessPiece = destPiece as! UIChessPiece
        return (sourceChessPiece.color == destChessPiece.color)
        
    }
    
    func nextTurn() {
       isWhiteTurn = !isWhiteTurn
    }
    
    func isTurnColor(sameAsPiece piece: UIChessPiece) -> Bool {
        if piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            if !isWhiteTurn {
                return true;
            }
        } else {
            if isWhiteTurn {
                return true;
            }
        }
        return false;
    }
    
    func isMoveOnBoard(forPieceFrom sourceIndex: BoardIndex, thatGoesTo destIndex: BoardIndex) -> Bool {
        if case 0..<theChessBoard.ROWS = sourceIndex.row {
            if case 0..<theChessBoard.COLS = sourceIndex.col {
                if case 0..<theChessBoard.ROWS = destIndex.row {
                    if case 0..<theChessBoard.COLS = destIndex.col {
                        return true
                    }
                }
            }
        }
        return false
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
