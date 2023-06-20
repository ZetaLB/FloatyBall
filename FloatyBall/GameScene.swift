//
//  GameScene.swift
//  FloatyBall
//
//  Created by Zeta Lenhart-Boyd on 4/21/23.
//


// MAKE THEM APPEAR FASTER OVER TIME

import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let upArrow = Button(fileName: "up", button: Button.buttonType.up)
    let downArrow = Button(fileName: "down", button: Button.buttonType.down)
    let rightArrow = Button(fileName: "right", button: Button.buttonType.right)
    let leftArrow = Button(fileName: "left", button: Button.buttonType.left)
    
    enum direction {
        case moveUp, moveRight, moveDown, moveLeft
    }
    
    var presentingView: GameView? = nil
    
    var powerUpRadius = 5.0
    var powerUpTime = 0.0
    var powerUpAddTime = 10.0
    
    var powerDownRadius = 5.0
    var powerDownTime = 0.0
    var powerDownAddTime = 10.0
    
    let myBallRadius = 20.0
    var myBall = ball(newRadius: 20.0)
    var ballDuration = 0.1
    var ballDurationChange = 0.03
    var ballDurationOriginal = 0.1
    var wallDistance = 22.0
    
    let maxBallSize = 40.0
    let minBallSize = 10.0
    let radiusChange = 10.0
    
    var score = 0
    var currentHighScoreData = gameData()
    
    var goodieTime = 0.0
    var addGoodieTime = 5.0
    var goodieList = [goodies]()
    let goodieSound = SKAction.playSoundFileNamed("zapThreeToneUp", waitForCompletion: false)
    
    var goodieBaddieSpeed = 0.5
    var goodieBaddieDirection = 10.0
    
    var baddieTime = 0.0
    var addBaddieTime = 5.0
    var baddieList = [baddies]()
    let baddieSound = SKAction.playSoundFileNamed("mixkit-arcade-retro-game-over-213", waitForCompletion: false)
    
    let xChange = 10.0
    let yChange = 10.0
    
    let sideGap = 20
    let topGap = 50
    let bottomGap = 30
    let buttonDiameter = 74
    var buttons: [Button] = []
    var liveButtons: [UITouch:Button] = [:]
    
    var isGameOver = false
    
    var scoreLable = SKLabelNode(text: "Score: 0")
    
    var playSounds = false
    
    func toggleSound(offOrOn: Bool) {
        playSounds = offOrOn
    }
    
    func setHighScore(TheScoreData: gameData) {
        currentHighScoreData = TheScoreData
    }
    
    override func didMove(to view: SKView) {
        
        view.isMultipleTouchEnabled = true
        
        // add arrow keys to the game scene
        upArrow.position = CGPoint(x: sideGap + buttonDiameter/2, y: bottomGap + buttonDiameter + bottomGap + buttonDiameter/2)
        upArrow.zPosition = 2
        addChild(upArrow)
        buttons.append(upArrow)
        
        downArrow.position = CGPoint(x: sideGap + buttonDiameter/2, y: bottomGap + buttonDiameter/2)
        downArrow.zPosition = 2
        addChild(downArrow)
        buttons.append(downArrow)
        
        rightArrow.position = CGPoint(x: Int(frame.maxX) - sideGap - buttonDiameter/2, y: bottomGap * 3/2 + buttonDiameter)
        rightArrow.zPosition = 2
        addChild(rightArrow)
        buttons.append(rightArrow)
        
        leftArrow.position = CGPoint(x: Int(frame.maxX) - sideGap * 2 - buttonDiameter * 3/2, y: bottomGap * 3/2 + buttonDiameter)
        leftArrow.zPosition = 2
        addChild(leftArrow)
        buttons.append(leftArrow)
        
        scoreLable.position = CGPoint(x: frame.midX, y: frame.maxY - CGFloat(topGap))
        scoreLable.zPosition = 2
        addChild(scoreLable)
        
        // add ball to the game scene
        myBall.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(myBall)
        
        
        // alt physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        print("didBegin")
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // remove goodies
        if nodeA.name == "ball" && nodeB.name == "goodie" {
            removeGoodie(goodie: nodeB)
            // PLAY A SOUND ////////////////////////////////////////////////////////////////////
            var currentBallRadius = myBall.ballRadius
            if currentBallRadius >= maxBallSize {
                score += 1
                for goodie in goodieList {
                    goodie.flip()
                }
                for baddie in baddieList {
                    baddie.flipBaddies()
                }
                ballDuration = ballDurationOriginal
                if addGoodieTime > 2.0 && score < 10 {
                    addGoodieTime -= 1.0
                }
                else if addGoodieTime > 2.0 && score < 20 {
                    addGoodieTime -= 0.5
                }
                if addBaddieTime > 2.0 {
                    addBaddieTime -= 1.0
                }
                scoreLable.text = String("Score: \(score)")
                currentBallRadius = myBallRadius
                // making sure ball doesnt go thru the wall with new radius
                wallDistance = myBallRadius
                if goodieBaddieSpeed > 0.2 {
                    goodieBaddieSpeed -= 0.1
                }
            }
            else {
                currentBallRadius += radiusChange
                wallDistance += radiusChange
                ballDuration += ballDurationChange
            }
            let currentPosition = myBall.position
            myBall.removeFromParent()
            myBall = ball(newRadius: currentBallRadius)
            myBall.position = currentPosition
            addChild(myBall)
            print("contact")
        }
        else if nodeA.name == "goodie" && nodeB.name == "ball" {
            removeGoodie(goodie: nodeA)
            let currentPosition = myBall.position
            var currrentBallRadius = myBall.ballRadius
            if currrentBallRadius >= maxBallSize {
                score += 1
                for goodie in goodieList {
                    goodie.flip()
                }
                for baddie in baddieList {
                    baddie.flipBaddies()
                }
                ballDuration = ballDurationOriginal
                if addGoodieTime > 2.0 && score < 10 {
                    addGoodieTime -= 1.0
                }
                else if addGoodieTime > 2.0 && score < 20 {
                    addGoodieTime -= 0.5
                }
                if addBaddieTime > 1.0 {
                    addBaddieTime -= 1.0
                }
                scoreLable.text = String("Score: \(score)")
                currrentBallRadius = myBallRadius
                wallDistance = myBallRadius
                if goodieBaddieSpeed > 0.2 {
                    goodieBaddieSpeed -= 0.1
                }
            }
            else {
                currrentBallRadius += radiusChange
                wallDistance += radiusChange
                ballDuration += ballDurationChange
            }
            myBall.removeFromParent()
            myBall = ball(newRadius: currrentBallRadius)
            myBall.position = currentPosition
            addChild(myBall)
            print("contact")
        }
        // remove baddies
        else if nodeA.name == "ball" && nodeB.name == "baddie" {
            removeBaddie(baddie: nodeB)
            let currentPosition = myBall.position
            let currrentBallRadius = myBall.ballRadius
            ballDuration -= ballDurationChange
            wallDistance -= radiusChange
            if currrentBallRadius <= minBallSize {
                let endLable = SKLabelNode(text: "Game Over")
                endLable.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(endLable)
                isGameOver = true
                return
            }
            myBall.removeFromParent()
            myBall = ball(newRadius: currrentBallRadius - radiusChange)
            myBall.position = currentPosition
            addChild(myBall)
        }
        else if nodeA.name == "baddie" && nodeB.name == "ball"{
            removeBaddie(baddie: nodeA)
            let currentPosition = myBall.position
            let currrentBallRadius = myBall.ballRadius
            ballDuration -= ballDurationChange
            wallDistance -= radiusChange
            if currrentBallRadius <= minBallSize {
                let endLable = SKLabelNode(text: "Game Over")
                endLable.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(endLable)
                isGameOver = true
                return
            }
            myBall.removeFromParent()
            myBall = ball(newRadius: currrentBallRadius - radiusChange)
            myBall.position = currentPosition
            addChild(myBall)
        }
        else if nodeA.name == "powerUp" && nodeB.name == "ball" {
            removePowerUp(PowerUp: nodeA)
        }
        else if nodeB.name == "powerUp" && nodeA.name == "ball" {
            removePowerUp(PowerUp: nodeB)
        }
        else if nodeA.name == "powerDown" && nodeB.name == "ball" {
            removePowerDown(PowerDown: nodeA)
        }
        else if nodeB.name == "powerDown" && nodeA.name == "ball" {
            removePowerDown(PowerDown: nodeB)
        }
    }
    
    func removeGoodie(goodie: SKNode) {
        goodie.removeFromParent()
        if playSounds {
            run(goodieSound)
        }
    }
    
    func removeBaddie(baddie: SKNode) {
        baddie.removeFromParent()
        if playSounds {
            run(baddieSound)
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        if isGameOver == true {
            if currentHighScoreData.score < score {
                currentHighScoreData.score = score
            }
            stopGame()
            return }
        handleFPSLabel()
        
        if let view = self.view {
            view.showsPhysics = true
        }
        // place random powerUp
        if powerUpTime == 0.0 {
            powerUpTime = currentTime
        }
        else if powerUpTime != 0.0 && powerUpTime + powerUpAddTime < currentTime {
            makePowerUp()
            powerUpTime = currentTime
        }
        
        // place a random powerDown
        if powerDownTime == 0.0 {
            powerDownTime = currentTime
        }
        else if powerDownTime != 0.0 && powerDownTime + powerDownAddTime < currentTime {
            makePowerDown()
            powerDownTime = currentTime
        }
        
        // place random goodie
        if goodieTime == 0.0 {
            goodieTime = currentTime
        }
        
        else if goodieTime != 0.0 && goodieTime + addGoodieTime < currentTime {
            var moveDirection = direction.moveUp
            var Position = 0
            let randomInt = Int.random(in: 1..<5)
            if randomInt == 1 {
                moveDirection = direction.moveDown
                Position = Int(CGFloat.random(in: frame.minX + 20...frame.maxX - 20))
            }
            else if randomInt == 2 {
                moveDirection = direction.moveLeft
                Position = Int(CGFloat.random(in: frame.minY + 20...frame.maxY - 20))
            }
            else if randomInt == 3 {
                moveDirection = direction.moveRight
                Position = Int(CGFloat.random(in: frame.minY + 20...frame.maxY - 20))
            }
            else if randomInt == 4 {
                moveDirection = direction.moveUp
                Position = Int(CGFloat.random(in: frame.minX...frame.maxX))
            }
            let newGoodie = goodies(direction: moveDirection, position: Position, frame: frame)
            addChild(newGoodie)
            goodieList.append(newGoodie)
            goodieTime = currentTime
        }
        
        // place random baddie
        if baddieTime == 0.0 {
            baddieTime = currentTime
        }
        
        else if baddieTime != 0.0 && baddieTime + addBaddieTime < currentTime {
            var moveDirection = direction.moveUp
            var Position = 0
            let randomInt = Int.random(in: 1..<5)
            if randomInt == 1 {
                moveDirection = direction.moveDown
                Position = Int(CGFloat.random(in: frame.minX...frame.maxX))
            }
            else if randomInt == 2 {
                moveDirection = direction.moveLeft
                Position = Int(CGFloat.random(in: frame.minY...frame.maxY))
            }
            else if randomInt == 3 {
                moveDirection = direction.moveRight
                Position = Int(CGFloat.random(in: frame.minY...frame.maxY))
            }
            else if randomInt == 4 {
                moveDirection = direction.moveUp
                Position = Int(CGFloat.random(in: frame.minX...frame.maxX))
            }
            let newBaddie = baddies(direction: moveDirection, position: Position, frame: frame)
            addChild(newBaddie)
            baddieList.append(newBaddie)
            baddieTime = currentTime
        }
        
        // move the goodie
        for goodie in goodieList {
            goodie.update(screen: frame, currentDuration: goodieBaddieSpeed)
        }
        // move the baddie
        for baddie in baddieList {
            baddie.update(screen: frame, currentDuration: goodieBaddieSpeed)
        }
        
        for button in liveButtons {
            if button.value.buttonDirection == Button.buttonType.up{
                if myBall.position.y + CGFloat(wallDistance) >= frame.maxY {
                    myBall.updateY(Ychange: 0.0, currentYDuration: ballDuration)
                }
                else {
                    myBall.updateY(Ychange: yChange, currentYDuration: ballDuration)
                    //print("move up")
                }
            }
            else if button.value.buttonDirection == Button.buttonType.down {
                if myBall.position.y - CGFloat(wallDistance) <= frame.minY {
                    myBall.updateY(Ychange: 0.0, currentYDuration: ballDuration)
                }
                else {
                    myBall.updateY(Ychange: yChange * -1, currentYDuration: ballDuration)
                    //print("move down")
                }
            }
            else if button.value.buttonDirection == Button.buttonType.left {
                if myBall.position.x - CGFloat(wallDistance) <= frame.minX {
                    myBall.updateX(Xchange: 0.0, currentXDuration: ballDuration)
                }
                else {
                    myBall.updateX(Xchange: xChange * -1, currentXDuration: ballDuration)
                    //print("move left")
                }
            }
            else if button.value.buttonDirection == Button.buttonType.right{
                if myBall.position.x + CGFloat(wallDistance) >= frame.maxX {
                    myBall.updateX(Xchange: 0.0, currentXDuration: ballDuration)
                    //print("move right")
                }
                else {
                    myBall.updateX(Xchange: xChange, currentXDuration: ballDuration)
                }
            }
            myBall.update(screen: frame)
        }
        
    }
    
    func handleFPSLabel() {
        guard let view = self.view else { return }

        if !view.showsFPS {
            view.showsFPS = true
        }
    }
        
        func closeEnough(_ target: SKSpriteNode, _ touch: UITouch) -> Bool {
            let targetPosition = target.position
            let touchPosition = touch.location(in: self)
            
            let closeInX = abs(targetPosition.x - touchPosition.x) <= (CGFloat(buttonDiameter) / 2)
            let closeInY = abs(targetPosition.y - touchPosition.y) <= (CGFloat(buttonDiameter) / 2)
            
            return closeInX && closeInY
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touch - began")
            
            for touch in touches {
                for button in buttons {
                    if closeEnough(button, touch) {
                        liveButtons[touch] = button
                    }
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let myButton = liveButtons[touch]
                if myButton?.buttonDirection == Button.buttonType.up {
                    myBall.updateY(Ychange: 0.0, currentYDuration: ballDuration)
                }
                else if myButton?.buttonDirection == Button.buttonType.down {
                    myBall.updateY(Ychange: 0.0, currentYDuration: ballDuration)
                }
                else if myButton?.buttonDirection == Button.buttonType.right {
                    myBall.updateX(Xchange: 0.0, currentXDuration: ballDuration)
                }
                else if myButton?.buttonDirection == Button.buttonType.left {
                    myBall.updateX(Xchange: 0.0, currentXDuration: ballDuration)
                }
                liveButtons.removeValue(forKey: touch)
            }
        }
    
    func makePowerUp() {
        let powerUp = SKShapeNode(circleOfRadius: powerUpRadius)
        powerUp.fillColor = .yellow
        powerUp.strokeColor = .yellow
        powerUp.position.x = CGFloat.random(in: 2 * powerUpRadius...frame.maxX - 2 * powerUpRadius)
        powerUp.position.y = CGFloat.random(in: 2 * powerUpRadius...frame.maxY - 2 * powerUpRadius)
        powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUpRadius)
        powerUp.physicsBody?.isDynamic = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        powerUp.name = "powerUp"
        addChild(powerUp)
        powerUp.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 5.0),
                SKAction.removeFromParent()
            ])
        )
    }
    
    func makePowerDown() {
        let powerDown = SKShapeNode(circleOfRadius: powerDownRadius)
        powerDown.fillColor = .orange
        powerDown.strokeColor = .orange
        powerDown.position.x = CGFloat.random(in: 2 * powerDownRadius...frame.maxX - 2 * powerDownRadius)
        powerDown.position.y = CGFloat.random(in: 2 * powerDownRadius...frame.maxY - 2 * powerDownRadius)
        powerDown.physicsBody = SKPhysicsBody(circleOfRadius: powerDownRadius)
        powerDown.physicsBody?.isDynamic = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        powerDown.name = "powerDown"
        addChild(powerDown)
        powerDown.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 5.0),
                SKAction.removeFromParent()
            ])
        )
    }
    
    func removePowerUp(PowerUp: SKNode) {
        for baddie in baddieList{
            baddie.removeFromParent()
        }
        PowerUp.removeFromParent()
    }
    
    func removePowerDown(PowerDown: SKNode) {
        for goodie in goodieList{
            goodie.removeFromParent()
        }
        PowerDown.removeFromParent()
    }
    
    func stopGame() {
        presentingView?.dismiss()
    }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                liveButtons.removeValue(forKey: touch)
            }
        }
    }
