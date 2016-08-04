//
//  GameScene.swift
//  RobotArena
//
//  Created by Christopher Yang on 7/13/16.
//  Copyright (c) 2016 MakeSchool. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var _dLastShootTime: CFTimeInterval = 1

    var robotOne: Robot!
    var robotTwo: Robot!
    var robotOneHealth: CGFloat = 1.0 {
        didSet {
            /* Cap Health */
            if robotOneHealth > 1.0 { robotOneHealth = 1.0 }
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            robotOneHealthBar.yScale = robotOneHealth
        }
    }
    var robotTwoHealth: CGFloat = 1.0 {
        didSet {
            /* Cap Health */
            if robotTwoHealth > 1.0 { robotTwoHealth = 1.0 }
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            robotTwoHealthBar.yScale = robotTwoHealth
        }
    }
    

    enum CollisionCategory: UInt32 {
        case bullet = 2
    }
    enum CollisionContact: UInt32 {
        case bullet = 1
    }
    enum GameState {
        case Title, Ready, Playing, GameOver
    }
    var labelOne: SKLabelNode!
    var labelTwo: SKLabelNode!
    var labelThree: SKLabelNode!
    var labelFour: SKLabelNode!
    var robotOneBullets: [Bullet] = []
    var robotTwoBullets: [Bullet] = []
    var bullet: Bullet!
    var labelUno: String = "TAP HERE TO MOVE" {
        didSet {
            labelOne.text = String(labelUno)
        }
    }
    var labelDos: String = "TAP HERE TO FIRE" {
        didSet {
            labelTwo.text = String(labelDos)
        }
    }
    var labelCuatro: String = "TAP HERE TO MOVE" {
        didSet {
            labelFour.text = String(labelCuatro)
        }
    }
    var labelTres: String = "TAP HERE TO FIRE" {
        didSet {
            labelThree.text = String(labelTres)
        }
    }
    var robotOneHealthBar: SKSpriteNode!
    
    var robotTwoHealthBar: SKSpriteNode!
    
    var backgroundOne: SKSpriteNode!
    
    var backgroundTwo: SKSpriteNode!
    
    var restartButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        robotOne = childNodeWithName("robotOne") as! Robot
        
        robotTwo = childNodeWithName("robotTwo") as! Robot
        
        labelOne = childNodeWithName("labelOne") as! SKLabelNode
        
        labelTwo = childNodeWithName("labelTwo") as! SKLabelNode
        
        labelThree = childNodeWithName("labelThree") as! SKLabelNode
        
        labelFour = childNodeWithName("labelFour") as! SKLabelNode
        
        bullet = childNodeWithName("bullet") as! Bullet
        
        backgroundOne = childNodeWithName("backgroundOne") as! SKSpriteNode
        
        backgroundTwo = childNodeWithName("backgroundTwo") as! SKSpriteNode
        
        robotOneHealthBar = childNodeWithName("robotOneHealthBar") as! SKSpriteNode
        
        robotTwoHealthBar = childNodeWithName("robotTwoHealthBar") as! SKSpriteNode
        
        restartButton = childNodeWithName("restartButton") as! MSButtonNode
        

        physicsWorld.contactDelegate = self
        
        backgroundOne.hidden = false
        
        backgroundTwo.hidden = false
        
        restartButton.hidden = true

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {


       /*     if touch.locationInNode(self).x > 284 {
                robotTwo.position.y = touch.locationInNode(self).y
            } else {
                robotOne.position.y = touch.locationInNode(self).y
 
            }
 */
            if touch.locationInNode(self).x < 142 {
                backgroundOne.hidden = true
                labelUno.removeAll()
            } else if touch.locationInNode(self).x < 426  && touch.locationInNode(self).x > 284 {
                labelTres.removeAll()
/*
                let bullet = SKSpriteNode()
                bullet.color = UIColor.greenColor()
                bullet.size = CGSize(width: 5,height: 5)
                
                bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
                bullet.physicsBody?.dynamic = true
                bullet.physicsBody?.affectedByGravity = false
                bullet.physicsBody?.categoryBitMask = CollisionCategory.bullet.rawValue
                bullet.physicsBody?.contactTestBitMask = CollisionContact.bullet.rawValue
                bullet.physicsBody?.collisionBitMask = 0x0
                bullet.position = CGPointMake(robotTwo.position.x, robotTwo.position.y)
                self.addChild(bullet) */
                
                let node = addBullet(robotTwo.position.x - 50, yPos: robotTwo.position.y)
                //robotTwoBullets.append(node)

                print(robotTwoBullets.indexOf(node))
                // Determine vector to targetSprite
                let vector = CGVectorMake((touch.locationInNode(self).x-robotTwo.position.x) * 100, (touch.locationInNode(self).y-robotTwo.position.y) * 100)
                
                
                fireBullet(node, vector: vector)
              
                
            } else if touch.locationInNode(self).x > 142 && touch.locationInNode(self).x < 284 {
                labelDos.removeAll()
            /*
            let bullet = SKSpriteNode()
            bullet.color = UIColor.greenColor()
            bullet.size = CGSize(width: 5,height: 5)
                
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody?.dynamic = true
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = CollisionCategory.bullet.rawValue
            bullet.physicsBody?.contactTestBitMask = CollisionContact.bullet.rawValue
            bullet.physicsBody?.collisionBitMask = 0x0 
            
            bullet.position = CGPointMake(robotOne.position.x, robotOne.position.y)
            self.addChild(bullet) */
            
                let node = addBullet(robotOne.position.x + 50, yPos: robotOne.position.y)
                //robotOneBullets.append(node)
                
            
            // Determine vector to targetSprite
            let vector = CGVectorMake((touch.locationInNode(self).x-robotOne.position.x) * 100, (touch.locationInNode(self).y-robotOne.position.y) * 100)
                print(vector)
            
            // Create the action to move the bullet. Don't forget to remove the bullet!
          //  let bulletAction = SKAction.sequence([SKAction.repeatAction(SKAction.moveBy(vector, duration: 1), count: 10) ,  SKAction.waitForDuration(30.0/60.0), SKAction.removeFromParent()])
                
                fireBullet(node, vector: vector)

                
                
            } else if touch.locationInNode(self).x > 426{
                labelCuatro.removeAll()
                backgroundTwo.hidden = true
            }
            
        }
 
    }
    func didBeginContact(contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        /* Check if either physics bodies was a seal */
        print("Contact was made")
        
        if contactA.categoryBitMask == 1 || contactB.categoryBitMask == 1 {
            
            robotOneHealth -= 0.01
            print("Robot One hit!")
            removeBullet(nodeB)
            
           // robotTwoBullets.removeFirst()
            
            
        }
        if contactA.categoryBitMask == 3 || contactB.categoryBitMask == 3 {
            
            robotTwoHealth -= 0.01
            print("Robot Two hit!")
            removeBullet(nodeB)
            // robotOneBullets.removeFirst()
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        for touch in touches {

            if touch.locationInNode(self).x > 426 {
                robotTwo.position.y = touch.locationInNode(self).y
            } else if touch.locationInNode(self).x < 142 {
                robotOne.position.y = touch.locationInNode(self).y
            }
        }
    }
    func gesture(sender: UILongPressGestureRecognizer) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if robotOneHealth < 0 || robotTwoHealth < 0 { gameOver() }
        if currentTime - _dLastShootTime >= 1 {

            shoot(robotOne.position.x + 50, yPos: robotOne.position.y, vector: CGVector(dx: 1000, dy: 0))
            shoot(robotTwo.position.x - 50, yPos: robotTwo.position.y, vector: CGVector(dx: -1000, dy: 0))
            _dLastShootTime=currentTime
        }
    }
    func addBullet(xPos: CGFloat, yPos: CGFloat) -> Bullet {
        let newBullet = bullet.copy() as! Bullet
        newBullet.position = CGPointMake(xPos, yPos)
        addChild(newBullet)
        if xPos < 284 {
            robotOneBullets.append(newBullet)
        }
        if xPos > 284 {
            robotTwoBullets.append(newBullet)
        }
        return newBullet

    }
    func fireBullet(bullet: SKSpriteNode, vector: CGVector) {

        let bulletAction = SKAction.moveBy(vector, duration: 75)
        bullet.runAction(bulletAction)
        
    }
    
    func gameOver() {
        

        
        /* Change play button selection handler */
            restartButton.hidden = false
        
        restartButton.selectedHandler = {
        
            /* Grab reference to the SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart GameScene */
            skView.presentScene(scene)
        }
    }
    func shoot(xPos: CGFloat, yPos: CGFloat, vector: CGVector) {
        let newBullet = bullet.copy() as! Bullet
        newBullet.position = CGPointMake(xPos, yPos)
        addChild(newBullet)
        
        let bulletAction = SKAction.moveBy(vector, duration: 5)
        newBullet.runAction(bulletAction)
        robotOneBullets.append(newBullet)
        robotTwoBullets.append(newBullet)

    }
    func removeBullet(node: SKNode) {
        let bulletRemoved = SKAction.runBlock({
            node.removeFromParent()
        })
        self.runAction(bulletRemoved)
    }
}


