//
//  MultiplayerView.swift
//  TicTacToe
//
//  Created by Ian Creech on 12/9/20.
//

import SwiftUI

struct MultiplayerView: View {
    @State var gameBoard: Board = Board()
    @State var done = false
    @State var msg = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Two Player")
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
                        .frame(width: getDemension(), height: getDemension())
                        .cornerRadius(15)
                        .onTapGesture(perform: {
                            makeMove(index: index) // applying move to UI
                            formatAlert() // shows formatted alert if end state
                        })
                    }
                }
                .padding(15)
            }
            .alert(isPresented: $done, content: {
                // Game over alert with reset game button
                Alert(title: Text("Game Over"), message: Text(msg), dismissButton: .destructive(Text("Play Again"), action: {
                    gameBoard = Board() // creates new 'empty' (.E) board
                }))
            })
        }
    }
    
    // Gets demenision of the device screen for formatting squares in UI
    func getDemension() -> CGFloat {
        let demension = UIScreen.main.bounds.width - (30 + 30) // considers padding applied
        return demension / 3 // three squares per row
    }
    
    // Applies move made to UI
    func makeMove(index: Int) {
        // Only allow move if location is has enum value of .E (empty)
        if !gameBoard.isTaken(index: index) {
            gameBoard = gameBoard.move(index) // player move
        }
    }
    
    // Formats alert based on end state
    func formatAlert() {
        if gameBoard.isWin == true {
            msg = "Winner"
            done = true
        }
        else if gameBoard.isDraw == true {
            msg = "Tie"
            done = true
        }
    }
}

struct MultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerView()
    }
}
