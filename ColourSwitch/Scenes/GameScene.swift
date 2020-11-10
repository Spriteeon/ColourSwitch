//
//  GameScene.swift
//  ColourSwitch
//
//  Created by COWARD, MALACHI (Student) on 10/11/2020.
//  Copyright © 2020 COWARD, MALACHI (Student). All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var colourSwitch: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colourSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colourSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colourSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colourSwitch.size.height)
        
        colourSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colourSwitch.size.width/2)
        colourSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colourSwitch.physicsBody?.isDynamic = false
        
        addChild(colourSwitch)
        
        spawnBall()
    }
    
    func spawnBall(){
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
}
