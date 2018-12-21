//
//  ViewController.swift
//  Chess
//
//  Created by Riad Mohamed on 12/7/18.
//  Copyright © 2018 Riad Mohamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblDisplayTurnOUTLET: UILabel!
    @IBOutlet weak var lblDisplayCheckOUTLET: UILabel!
    @IBOutlet var panOUTLET: UIPanGestureRecognizer!
    var pieceDragged: UIChessPiece!
    var sourceOrigin: CGPoint!
    var destOrigin: CGPoint!
    static var SPACE_FROM_LEFT_EDGE = 35
    static var SPACE_FROM_TOP_EDGE = 181
    static var TILE_SIZE = 38
    var myChessGame: ChessGame!
    var chessPieces: [UIChessPiece]!
    
    override func viewDidLoad() {	
        super.viewDidLoad()
        
        chessPieces = []
        myChessGame = ChessGame.init(viewController: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pieceDragged = touches.first!.view as? UIChessPiece
        
        if pieceDragged != nil {
            sourceOrigin = pieceDragged.frame.origin
			let possibleMoves = myChessGame.getArrayOfPossibleMoves(forPiece: pieceDragged)
			for moveIndex in possibleMoves {
				let possibleTile = myChessGame.theChessBoard.board[moveIndex.row][moveIndex.col]
				switch possibleTile {
				case is Dummy:
					let tempView = UIChessPiece(frame: CGRect(origin: CGPoint(x: possibleTile.x, y: possibleTile.y), size: CGSize(width: 38, height: 38)))
					tempView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
				case is UIChessPiece:
					(possibleTile as! UIChessPiece).backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
				default:
					break
				}
			}
		}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pieceDragged != nil {
            drag(piece: pieceDragged, usingGestureRecognizer: panOUTLET)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pieceDragged != nil {
            let touchLocation = touches.first!.location(in: view)
            
            var x = Int(touchLocation.x)
            var y = Int(touchLocation.y)
            
            x -= ViewController.SPACE_FROM_LEFT_EDGE
            y -= ViewController.SPACE_FROM_TOP_EDGE
            
            x = (x / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
            y = (y / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
            
            x += ViewController.SPACE_FROM_LEFT_EDGE
            y += ViewController.SPACE_FROM_TOP_EDGE
            
            destOrigin = CGPoint(x: x, y: y)
            let sourceIndex = ChessBoard.indexOf(origin: sourceOrigin)
            let destIndex = ChessBoard.indexOf(origin: destOrigin)
            
            if myChessGame.isMoveValid(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex) {
                myChessGame.move(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex, toOrigin: destOrigin)
				
				// check if game is over
				if myChessGame.isGameover() {
					displayWinner()
					return
				}
				
				if shouldPromotePawn() {
					promptForPawnPromotion()
				} else {
					resumeGame()
				}
				let possibleMoves = myChessGame.getArrayOfPossibleMoves(forPiece: pieceDragged)
				for moveIndex in possibleMoves {
					let possibleTile = myChessGame.theChessBoard.board[moveIndex.row][moveIndex.col]
					switch possibleTile {
					case is Dummy:
						let tempView = UIChessPiece(frame: CGRect(origin: CGPoint(x: possibleTile.x, y: possibleTile.y), size: CGSize(width: 38, height: 38)))
						tempView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0)
					case is UIChessPiece:
						(possibleTile as! UIChessPiece).backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0)
					default:
						break
					}
				}

            } else {
                pieceDragged.frame.origin = sourceOrigin
            }
        
        }
    }
	
	
	func resumeGame() {
		// Display the check
		displayCheck()
		// Change the turn
		myChessGame.nextTurn()
		// Display turn on screen
		updateTurnOnScreen()
	}
	
	func promote(pawn pawnToBePromoted: Pawn, into pieceName: String) {
		let pawnColor = pawnToBePromoted.color
		let pawnFrame = pawnToBePromoted.frame
		let pawnIndex = ChessBoard.indexOf(origin: pawnToBePromoted.frame.origin)
		
		myChessGame.theChessBoard.remove(piece: pawnToBePromoted)
		
		switch pieceName {
		case "Queen":
			myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: pawnFrame, color: pawnColor, vc: self)
		case "Knight":
			myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: pawnFrame, color: pawnColor, vc: self)
		case "Rook":
			myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Rook(frame: pawnFrame, color: pawnColor, vc: self)
		case "Bishop":
			myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Bishop(frame: pawnFrame, color: pawnColor, vc: self)
		default:
			break
		}
	}
	
	func promptForPawnPromotion() {
		if let pawnToPromote = myChessGame.getPawnToBePromoted() {
			let box = UIAlertController(title: "Pawn Promotion", message: "Choose Piece", preferredStyle: .alert)
			box.addAction(UIAlertAction(title: "Queen", style: .default, handler: {
				action in self.promote(pawn: pawnToPromote, into: action.title!)
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Knight", style: .default, handler: {
				action in self.promote(pawn: pawnToPromote, into: action.title!)
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Rook", style: .default, handler: {
				action in self.promote(pawn: pawnToPromote, into: action.title!)
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Bishop", style: .default, handler: {
				action in self.promote(pawn: pawnToPromote, into: action.title!)
				self.resumeGame()
			}))
			
			self.present(box, animated: true, completion: nil)
		}
	}
	
	func shouldPromotePawn() -> Bool {
		return (myChessGame.getPawnToBePromoted() != nil)
	}
	
	func displayCheck() {
		let playerChecked = myChessGame.getPlayerChecked()
		
		if playerChecked != nil {
			lblDisplayCheckOUTLET.text = playerChecked! + " is in check"
		} else {
			lblDisplayCheckOUTLET.text = nil
		}
	}
	
	func displayWinner() {
		let box = UIAlertController(title: "Game Over", message: "\(myChessGame.winner!) wins", preferredStyle: .alert)
		
		box.addAction(UIAlertAction(title: "Back To Main Menu", style: .default, handler: {
			action in self.performSegue(withIdentifier: "backToMainMenu", sender: self)
		}))
		
		box.addAction(UIAlertAction(title: "Rematch", style: .default, handler: {
			action in
			
			// clear the screen, chess pieces array, board matrix
			for chessPiece in self.chessPieces {
				self.myChessGame.theChessBoard.remove(piece: chessPiece)
			}
			
			// create new game
			self.myChessGame = ChessGame(viewController: self)
			
			// update labels with game status
			self.updateTurnOnScreen()
			self.lblDisplayTurnOUTLET.text = nil
			self.lblDisplayCheckOUTLET.text = nil
		}))
		
		self.present(box, animated: true, completion: nil)
		
	}
    
    func updateTurnOnScreen() {
        lblDisplayTurnOUTLET.text = myChessGame.isWhiteTurn ? "White's turn" : "Black's turn"
        lblDisplayTurnOUTLET.textColor = myChessGame.isWhiteTurn ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func drag(piece: UIChessPiece, usingGestureRecognizer gestureRecognizer: UIPanGestureRecognizer){
        let translation = gestureRecognizer.translation(in: view)
        
        piece.center = CGPoint(x: translation.x + piece.center.x, y: translation.y + piece.center.y)
        
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
    }


}

