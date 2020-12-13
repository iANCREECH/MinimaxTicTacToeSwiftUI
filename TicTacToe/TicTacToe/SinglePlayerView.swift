//
//  GameView.swift
//  TicTacToe
//
//  Created by Ian Creech on 12/9/20.
//

import SwiftUI

struct SinglePlayerView: View {
    @State var gameBoard: Board = Board() // a game board instance
    @State var done = false // showing alert or not
    @State var msg = "" // stating win or draw on the alert message
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Single Player")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(0..<9, id: \.self) { index in
                        ZStack {
                            Color.blue
                            Color.red
                                .opacity(gameBoard.position[index].rawValue == "O" ? 1 : 0)
                            Color.white
                                .opacity(gameBoard.position[index].rawValue == " " ? 1 : 0)
                            
                            Text(gameBoard.returnPiece(index: index)) // shows appropriate game piece based on player move
                                .font(.system(size: 55))
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                        }
                        .frame(width: getDemension(), height: getDemension()) // generates size of each square based on device screen demensions
                        .cornerRadius(15)
                        .onTapGesture(perform: {
                            makeMove(index: index) // applying move to UI
                            gameResult(board: gameBoard) // shows formatted alert if end state
                        })
                    }
                }
                .padding(15)
            }
        }
        .alert(isPresented: $done, content: {
            // Game over alert with reset game button
            Alert(title: Text("Game Over"), message: Text(msg), dismissButton: .destructive(Text("Play Again"), action: {
                gameBoard = Board() // creates new 'empty' (.E) board
            }))
        })
    }
    
    // Gets demenision of the device screen for formatting squares in UI
    func getDemension() -> CGFloat {
        let demension = UIScreen.main.bounds.width - (30 + 30) // considers padding applied
        return demension / 3 // three squares per row
    }
    
    // Applies move made to UI
    func makeMove(index: Int) {
        if !gameBoard.isWin && !gameBoard.isDraw {
            if !gameBoard.isTaken(index: index) {
                gameBoard = gameBoard.move(index) // player move
                if gameBoard.solver(gameBoard) != -1 { // AI should make no move if end state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        gameBoard = gameBoard.move(gameBoard.solver(gameBoard)) // AI move
                    }
                }
            }
        }
    }
    
    // Formats alert
    func formatAlert(message: String) {
        msg = message
        done = true
    }
    
    // Formats alert based on end state
    func gameResult(board: Board) {
        let game = board
        let win = game.isWin
        let draw = game.isDraw
        
        if win {
            formatAlert(message: "Winner")
        } else if draw {
            formatAlert(message: "Tie")
        }
    }
    
}

struct SinglePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePlayerView()
    }
}
