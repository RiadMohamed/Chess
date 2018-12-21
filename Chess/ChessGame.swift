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
	var winner: String?
	
	func getArrayOfPossibleMoves(forPiece piece: UIChessPiece) -> [BoardIndex] {
		var arrayOfMoves: [BoardIndex] = []
		let source = theChessBoard.getIndex(forChessPiece: piece)!
		
		for row in 0..<theChessBoard.ROWS {
			for col in 0..<theChessBoard.COLS {
				let dest = BoardIndex(row: row, col: col)
				if isNormalMoveValid(forPiece: piece, fromIndex: source, toIndex: dest) {
					arrayOfMoves.append(dest)
				}
			}
		}
		return arrayOfMoves
	}
	
	func getPawnToBePromoted() -> Pawn? {
		for chessPiece in theChessBoard.vc.chessPieces {
			if let pawn = chessPiece as? Pawn {
				let pawnIndex = ChessBoard.indexOf(origin: pawn.frame.origin)
				if pawnIndex.row == 0 || pawnIndex.row == 7 {
					return pawn
				}
			}
		}
		return nil
	}
	
	func getPlayerChecked() -> String? {
		guard let whiteKingIndex = theChessBoard.getIndex(forChessPiece: theChessBoard.whiteKing)
			else {
				return nil
		}
		
		guard let blackKingIndex = theChessBoard.getIndex(forChessPiece: theChessBoard.blackKing)
			else {
				return nil
		}
		
		for row in 0..<theChessBoard.ROWS{
			for col in 0..<theChessBoard.COLS{
				if let chessPiece = theChessBoard.board[row][col] as? UIChessPiece {
					let chessPieceIndex = BoardIndex(row: row, col: col)
					if chessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
						if isNormalMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: whiteKingIndex) {
							return "White"
						}
					} else {
						if isNormalMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: blackKingIndex) {
							return "Black"
						}
					}
				}
			}
		}
		return nil
	}
	
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
	
	func isGameover() -> Bool {
		if didSomebodyWin() {
			return true
		}
		return false
	}
	
	func didSomebodyWin() -> Bool {
		if !(theChessBoard.vc.chessPieces.contains(theChessBoard.whiteKing)) {
			winner = "Black"
			return true
		}
		
		if !(theChessBoard.vc.chessPieces.contains(theChessBoard.blackKing)) {
			winner = "White"
			return true
		}
		return false
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
			if !(piece as! Knight).doesMoveSeemFine(fromIndex: source, toIndex: dest){
				return false
			}
		case is King:
			return isMoveValid(forKing: piece as! King, fromIndex: source, toIndex: dest)
		default:
			break
		}
		return true
	}
	
	func isMoveValid(forPawn pawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		if !pawn.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
			return false
		}
		
		// no attack
		if source.col == dest.col {
			// advance by 2
			if pawn.triesToAdvanceBy2 {
				var moveForward = 0
				if pawn.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
					moveForward = 1
				} else {
					moveForward = -1
				}
				
				if theChessBoard.board[dest.row][dest.col] is Dummy && theChessBoard.board[dest.row - moveForward][dest.col] is Dummy {
					return true
				}
			}
				// advance by 1
			else {
				if theChessBoard.board[dest.row][dest.col] is Dummy {
					return true
				}
			}
		}
			// attacking a piece
		else {
			if !(theChessBoard.board[dest.row][dest.col] is Dummy) {
				return true
			}
		}
		return false
	}
	
	func isMoveValid(forRookBishopQueen piece: UIChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		switch piece {
		case is Rook:
			if !(piece as! Rook).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		case is Bishop:
			if !(piece as! Bishop).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		default:
			if !(piece as! Queen).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		}
		
		var increaseRow = 0
		if dest.row - source.row != 0 {
			increaseRow = (dest.row - source.row) / abs(dest.row - source.row)
		}
		
		var increaseCol = 0
		if dest.col - source.col != 0 {
			increaseCol = (dest.col - source.col) / abs(dest.col - source.col)
		}
		
		var nextRow = source.row + increaseRow
		var nextCol = source.col + increaseCol
		
		while(nextRow != dest.row || nextCol != dest.col){
			if !(theChessBoard.board[nextRow][nextCol] is Dummy) {
				return false
			} else {
				nextRow += increaseRow
				nextCol += increaseCol
			}
		}
		return true
	}
	
	func isMoveValid(forKing king: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		if !king.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
			return false
		}
		
		if isOpponentKing(nearKing: king, thatGoesTo: dest) {
			return false
		}
		
		return true
	}
	
	func isOpponentKing(nearKing movingKing: King, thatGoesTo destIndexOfMovingKing: BoardIndex) -> Bool {
		var theOpponentKing: King
		if movingKing == theChessBoard.whiteKing {
			theOpponentKing = theChessBoard.blackKing
		} else {
			theOpponentKing = theChessBoard.whiteKing
		}
		
		// get index of opp King.
		var indexOfOpponentKing: BoardIndex!
		for row in 0..<theChessBoard.ROWS {
			for col in 0..<theChessBoard.COLS{
				if let aKing = theChessBoard.board[row][col] as? King, aKing == theOpponentKing {
					indexOfOpponentKing = BoardIndex(row: row, col: col)
				}
			}
		}
		
		// Compute absolute difference between kings
		let differenceInRows = abs(indexOfOpponentKing.row - destIndexOfMovingKing.row)
		let differenceInCols = abs(indexOfOpponentKing.col - destIndexOfMovingKing.col)
		
		// if they are too clsoe then move is rejected
		if case 0...1 = differenceInRows{
			if case 0...1 = differenceInCols {
				return true
			}
		}
		return false
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
