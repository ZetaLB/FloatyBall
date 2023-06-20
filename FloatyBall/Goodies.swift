//
//  Goodies.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/26/23.
//

import Foundation
import SpriteKit

class goodies: SKShapeNode {
    
    var width = 20
    var height = 40
    var myDirection = GameScene.direction.moveUp
    var xPosition = 0
    var yPostion = 0
    
    init(direction: GameScene.direction, position: Int, frame: CGRect) {
        super.init()
        myDirection = direction
        if myDirection == GameScene.direction.moveDown {
            width = 20
            height = 40
            xPosition = position
            yPostion = Int(frame.maxY)
            print("top goodie", xPosition, yPostion)
        }
        else if myDirection == GameScene.direction.moveUp {
            width = 20
            height = 40
            xPosition = position
            yPostion = Int(frame.minY) - height
            print("bottom goodie", xPosition, yPostion)
        }
        else if myDirection == GameScene.direction.moveLeft {
            width = 40
            height = 20
            xPosition = Int(frame.maxX)
            yPostion = position
            print("right goodie", xPosition, yPostion)
        }
        else if myDirection == GameScene.direction.moveRight {
            width = 40
            height = 20
            xPosition = Int(frame.minX) - width
            yPostion = position
            print("left goodie", xPosition, yPostion)
        }
        
        //let targetSize =  CGSize(width: width, height:height)
        let ellipsePath = UIBezierPath(ovalIn: CGRect(x: xPosition, y: yPostion, width: width, height: height))
        self.path = ellipsePath.cgPath
        self.fillColor = UIColor.green
        self.strokeColor = UIColor.yellow
        self.name = "goodie"
        // physics
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // change up to downs and vice versa and rights to lefts and vice versa
    func flip(){
        // switch up to down
        if myDirection == GameScene.direction.moveUp {
            myDirection = GameScene.direction.moveDown
        }
        // switch down to up
        else if myDirection == GameScene.direction.moveDown {
            myDirection = GameScene.direction.moveUp
        }
        // switch left to right
        else if myDirection == GameScene.direction.moveLeft {
            myDirection = GameScene.direction.moveRight
        }
        // switch right to left
        else if myDirection == GameScene.direction.moveRight {
            myDirection = GameScene.direction.moveLeft

        }
    }
    
    func update(screen: CGRect, currentDuration: Double) {
        if myDirection == GameScene.direction.moveUp {
            let moveGoodieUp = SKAction.moveTo(y: self.position.y + 10, duration: currentDuration)
            run(moveGoodieUp)
        }
        else if myDirection == GameScene.direction.moveDown {
            let moveGoodieDown = SKAction.moveTo(y: self.position.y - 10, duration: currentDuration)
            run(moveGoodieDown)
        }
        else if myDirection == GameScene.direction.moveLeft {
            let moveGoodieLeft = SKAction.moveTo(x: self.position.x - 10, duration: currentDuration)
            run(moveGoodieLeft)
        }
        else if myDirection == GameScene.direction.moveRight {
            let moveGoodieRight = SKAction.moveTo(x: self.position.x + 10, duration: currentDuration)
            run(moveGoodieRight)
        }
    }
}
