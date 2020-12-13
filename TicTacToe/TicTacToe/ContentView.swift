//
//  ContentView.swift
//  TicTacToe
//
//  Created by Ian Creech on 12/9/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Tic Tac Toe")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    NavigationLink(destination: SinglePlayerView()) {
                        Text("Single Player")
                            .padding()
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.blue)
                            )
                    }
                    .padding()
                    NavigationLink(destination: MultiplayerView()) {
                        Text("Two Player")
                            .padding()
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.blue)
                            )
                            
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
