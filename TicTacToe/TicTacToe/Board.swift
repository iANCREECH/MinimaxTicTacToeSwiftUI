//
//  Board.swift
//  TicTacToe
//
//  Created by Ian Creech on 12/9/20.
//

import Foundation
import SwiftUI

// Handles return of proper game piece based on turn
enum GamePiece: String {
    case X = "X"
    case O = "O"
    case E = " "
    var opp: GamePiece {
        switch self {
        case .X:
            return .O
        case .O:
            return .X
        case .E:
            return .E
        }
    }
}

// A move is an integer 0-8 indicating a place to put a piece
typealias Move = Int // easier readability

struct Board {
    let position: [GamePiece] // array of GamePiece (enmu values)
    let turn: GamePiece // current turn to be made (enum)
    let lastMove: Move // value of last move made (Int value)
    
    // The board is empty and "X" goes first by default
    // lastMove = -1 is the marking of a start position
    init(position: [GamePiece] = [.E, .E, .E, .E, .E, .E, .E, .E, .E], turn: GamePiece = .X, lastMove: Int = -1) {
        self.position = position
        self.turn = turn
        self.lastMove = lastMove
    }
    
    // Return "X" or "O"
    func returnPiece(index: Int) -> String {
        return position[index].rawValue
    }
    
    // Checks for "empty" (.E) location
    func isTaken(index: Int) -> Bool {
        if position[index] == .E {
            return false
        }
        else {
            return true
        }
    }
    
    // Location can be 0-8
    // return a newly generated board with the move played
    func move(_ location: Move) -> Board {
        var tempPosition = position
        tempPosition[location] = turn
        return Board(position: tempPosition, turn: turn.opp, lastMove: location)
    }
        
    // Empty squares are the only legal moves
    var legalMoves: [Move] {
        return position.indices.filter { position[$0] == .E }
    }
    
    // Checks if there is a winning combination
    var isWin: Bool {
        // Horizonal
        for i in stride(from: 0, to: 9, by: 3) {
            if position[i] == position[i + 1] && position[i] == position[i + 2] && position[i] != .E {
                return true
            }
        }
        
        // Vertical
        for i in 0...2 {
            if position[i] == position[i + 3] && position[i] == position[i + 6] && position[i] != .E {
                return true
            }
        }
        
        // Diagnol
        if position[0] == position[4] && position[0] == position[8] && position[0] != .E {
            return true
        }
        if position[2] == position[4] && position[2] == position[6] && position[2] != .E {
            return true
        }
        
        return false
    }
    
    // Returns a draw if no winner and no more legal moves
    var isDraw: Bool {
        return !isWin && legalMoves.count == 0
    }
    
    // Minimax function with alpha-beta pruning
    func minimax(_ board: Board, alpha: Int, beta: Int, maximizing: Bool, originPlayer: GamePiece) -> Int {
        var a = alpha
        var b = beta
        var value: Int

        // Base case
        if board.isWin && originPlayer == board.turn.opp { return 1 } // win
        else if board.isWin && originPlayer != board.turn.opp { return -1 } // loss
        else if board.isDraw { return 0 } // draw
        
        // Maximizing player
        if maximizing {
            value = Int.min
            //var bestValue = Int.min
            for move in board.legalMoves {
                value = max(value, minimax(board.move(move), alpha: a, beta: b, maximizing: false, originPlayer: originPlayer))
                a = max(a, value)
                if a >= b {
                    break // beta cut off
                }
            }
            return value
        }
        // Minimizing player
        else {
            value = Int.max
            //var worstValue = Int.max
            for move in board.legalMoves {
                value = min(value, minimax(board.move(move), alpha: a, beta: b, maximizing: true, originPlayer: originPlayer), value)
                b = max(b, value)
                if b <= a {
                    break // alpha cut off
                }
            }
            return value
        }
    }
    
    // Finds the best move for the current game state passed in
    func solver(_ board: Board) -> Move {
        var bestEval = Int.min
        var bestMove = -1
        // For each possible legal move
        for move in board.legalMoves {
            let result = minimax(board.move(move), alpha: Int.min, beta: Int.max, maximizing: false, originPlayer: board.turn) // minimax call
            if result > bestEval { // if the evaluation is not as good as the most recent result
                bestEval = result
                bestMove = move // get the move made if it was a better result
            }
        }
        return bestMove
    }
}
