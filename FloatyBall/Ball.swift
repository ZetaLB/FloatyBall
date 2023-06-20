//
//  Ball.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/21/23.
//

import Foundation
import SpriteKit

class ball: SKShapeNode {
    
    var moveX = 0.0
    var moveY = 0.0
    var ballRadius = 20.0
    var Xduration = 0.1
    var Yduration = 0.1
    //var duration = GameScene.ballDu
    
    init(newRadius: Double) {
        super.init()
        ballRadius = newRadius
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: ballRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        self.path = path
        self.lineWidth = 1
        self.fillColor = .blue
        self.strokeColor = .yellow
        self.glowWidth = 0.5
        self.name = "ball"
        // physics
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(screen: CGRect) {
        let moveBallx = SKAction.moveTo(x: self.position.x + moveX, duration: Xduration)
        self.run(moveBallx)
        let moveBally = SKAction.moveTo(y: self.position.y + moveY, duration: Yduration)
        self.run(moveBally)
        
    }
    
    func updateX(Xchange : Double, currentXDuration: Double) {
        moveX = Xchange
        Xduration = currentXDuration
    }
    
    func updateY(Ychange : Double, currentYDuration: Double) {
        moveY = Ychange
        Yduration = currentYDuration
    }
    
//    func updateCirclePathBigger() {
//        let path = CGMutablePath()
//        path.addArc(center: CGPoint.zero,
//                    radius: ballRadius + 10,
//                    startAngle: 0,
//                    endAngle: CGFloat.pi * 2,
//                    clockwise: true)
//    }
//    
//    func getBigger(bigRadius : Double) {
//        ballRadius = bigRadius + ballRadius
//    }
//
//    func getSmaller(smallRadius : Double) {
//        ballRadius = smallRadius - ballRadius
//    }
}
