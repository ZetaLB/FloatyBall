//
//  GameView.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/21/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var playSound = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var data: gameData
    
    init(sound: Bool){
        playSound = sound
    }
        var gameScene: SKScene {
            let scene = GameScene()
            // this approach mirrors an updated approach
            // available since the video was recorded
            scene.scaleMode = .resizeFill
            scene.toggleSound(offOrOn: playSound)
            scene.presentingView = self
            scene.setHighScore(TheScoreData: data)
            
            return scene
        }
        var body: some View {
            SpriteView(scene: gameScene)
        }
    }
    
    struct GameView_Previews: PreviewProvider {
        static var previews: some View {
            GameView(sound: false)
        }
    }
    
