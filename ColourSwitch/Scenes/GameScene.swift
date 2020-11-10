//
//  GameScene.swift
//  ColourSwitch
//
//  Created by COWARD, MALACHI (Student) on 10/11/2020.
//  Copyright © 2020 COWARD, MALACHI (Student). All rights reserved.
//

import SpriteKit

enum PlayColours {
    static let colours = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colourSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColourIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colourSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colourSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colourSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colourSwitch.size.height)
        colourSwitch.zPosition = ZPositions.colourSwitch
        
        colourSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colourSwitch.size.width/2)
        colourSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colourSwitch.physicsBody?.isDynamic = false
        
        addChild(colourSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall(){
        currentColourIndex = Int(arc4random_uniform(UInt32(4)))
        
        //let ball = SKSpriteNode(imageNamed: "ball")
        //ball.size = CGSize(width: 30.0, height: 30.0)
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColours.colours[currentColourIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colourSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver() {
        //print("GameOver!")
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            //print("Contact!")
            // Check which node is our Ball then assign it to the constant "Ball"
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                // Check if Player has selected the right Colour
                if currentColourIndex == switchState.rawValue {
                    //print("Correct!")
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25) , completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                } else {
                    gameOver()
                }
            }
        }
    }
}
