//
//  ChessBoard.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class ChessBoard: NSObject {
    var board: [[Piece]]!
    var vc: ViewController!
    let ROWS = 8
    let COLS = 8
    var whiteKing: King!
    var blackKing: King!
    
	func getIndex(forChessPiece chessPieceToFind: UIChessPiece) -> BoardIndex? {
		for row in 0..<ROWS {
			for col in 0..<COLS {
				let aChessPiece = board[row][col] as? UIChessPiece
				if chessPieceToFind == aChessPiece {
					return BoardIndex(row: row, col: col)
				}
			}
		}
		
		return nil
	}
	
    func remove(piece: Piece) {
        if let chessPiece = piece as? UIChessPiece {
            // remove from board matrix
            let indexOnBoard = ChessBoard.indexOf(origin: chessPiece.frame.origin)
            board[indexOnBoard.row][indexOnBoard.col] = Dummy(frame: chessPiece.frame)
            // remoce from array of chess pieces
            if let indexInChessPiecesArray = vc.chessPieces.lastIndex(of: chessPiece){
                vc.chessPieces.remove(at: indexInChessPiecesArray)
            }
            // remove from view
            chessPiece.removeFromSuperview()
            }
    }
    
    func place(chessPiece: UIChessPiece, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint){
        
        chessPiece.frame.origin = destOrigin
        board[destIndex.row][destIndex.col] = chessPiece
        
    }
    
    static func indexOf(origin: CGPoint) -> BoardIndex {
        let row = (Int(origin.y) - ViewController.SPACE_FROM_TOP_EDGE) / ViewController.TILE_SIZE
        let col = (Int(origin.x) - ViewController.SPACE_FROM_LEFT_EDGE) / ViewController.TILE_SIZE
        
        return BoardIndex(row: row, col: col)
    }
    
    func getFrame(forRow row: Int, forCol col: Int) -> CGRect {
        let x = CGFloat(ViewController.SPACE_FROM_LEFT_EDGE + col * ViewController.TILE_SIZE)
        let y = CGFloat(ViewController.SPACE_FROM_TOP_EDGE + row * ViewController.TILE_SIZE)
        
        return CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: ViewController.TILE_SIZE, height: ViewController.TILE_SIZE))
    }
    
    
    
    init(viewController: ViewController) {
        super.init()
        vc = viewController
        let oneRowOfBoard = Array(repeating: Dummy(), count: COLS)
        board = Array(repeating: oneRowOfBoard, count: ROWS)
        
        for row in 0..<ROWS {
            for col in 0..<COLS {
                switch row {
                case 0:
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 4:
                        blackKing = King(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                        board[row][col] = blackKing
                    case 5:
                        board[row][col] = Bishop(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    default:
                        board[row][col] = Rook(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    }
                case 1:
                    board[row][col] = Pawn(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                case 6:
                    board[row][col] = Pawn(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                case 7:
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 4:
                        whiteKing = King(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                        board[row][col] = whiteKing
                    case 5:
                        board[row][col] = Bishop(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    default:
                        board[row][col] = Rook(frame: getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
                    }
                default:
                    board[row][col] = Dummy(frame: getFrame(forRow: row, forCol: col))
                }
            }
        }
        
    }
}
