//
//  Button.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/21/23.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    
    var buttonDirection = buttonType.up
    
    enum buttonType {
        case up, down, right, left
    }
    
    init(fileName: String, button: buttonType) {
        buttonDirection = button
        let myTexture = SKTexture(imageNamed: fileName)
        super.init(texture: myTexture, color: .clear, size: CGSize(width: 74, height:74))
        print("button made")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
