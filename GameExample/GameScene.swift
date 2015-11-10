//
//  GameScene.swift
//  GameExample
//
//  Created by Bob Pascazio on 11/4/15.
//  Copyright (c) 2015 NYCDA. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All  : UInt32 = UInt32.max
    static let Monster : UInt32 = 0b1 // 1
    static let Projectile : UInt32 = 0b10 // 2
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self/length()
    }
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width*0.1, y: size.height*0.5)
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence(
                [SKAction.runBlock(addMonster),
                SKAction.waitForDuration(2)]
            )
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        
        
        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody!.dynamic = true
        projectile.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody!.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody!.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody!.usesPreciseCollisionDetection = true
        
        
        projectile.position = player.position
        
        let offset = touchLocation - projectile.position
        
        if (offset.x < 0) {return}
        
        addChild(projectile)
        
        let direction = offset.normalized()
        
        let shootAmount = direction * 1000
        
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max:CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody!.dynamic = true
        monster.physicsBody!.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        let actualY = random(monster.size.height/2, max:size.height-monster.size.height/2)
        
        monster.position = CGPoint(x:size.width + monster.size.width/2, y:actualY)
        
        addChild(monster)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        monster.runAction(SKAction.repeatActionForever(action))
        
        let actionScaleUp = SKAction.scaleBy(10.0, duration: 0.25)
        let actionScaleDown = SKAction.scaleBy(0.1, duration: 0.25)
        monster.runAction(SKAction.sequence([actionScaleUp,actionScaleDown]))
        
        
        let actualDuration = random(CGFloat(2.0), max:CGFloat(4.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x:-monster.size.width/2, y:actualY), duration: NSTimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    

    func projectDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        
        print("hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            
            projectDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
            
        }
        
        
    }
    
    
}
