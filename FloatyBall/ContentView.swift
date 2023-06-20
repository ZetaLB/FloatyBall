//
//  ContentView.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/21/23.
//

import SwiftUI
import SpriteKit


struct ContentView: View {
    
    @State var soundOn = false
    @StateObject var data = gameData()
    
    var body: some View {
        NavigationView  {
            VStack {
                Text("High Score: \(data.score)")
                    .fontWeight(.light)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(20.0)
                    .background(.black)
                Toggle(isOn: $soundOn) {
                    Text("Sound")
                        .fontWeight(.light)
                        .font(.title)
                        .padding(20.0)
                    
                }
                .padding(50)
                NavigationLink {
                    GameView(sound: soundOn)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Start a New Game")
                        .fontWeight(.light)
                        .font(.title)
                        .padding(20.0)
                        .foregroundColor(Color.white)
                        .background(Color.cyan)
                        .cornerRadius(15)
                }
            }
        }
        .environmentObject(data)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
