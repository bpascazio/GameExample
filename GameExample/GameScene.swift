//
//  GameScene.swift
//  GameExample
//
//  Created by Bob Pascazio on 11/4/15.
//  Copyright (c) 2015 NYCDA. All rights reserved.
//

import SpriteKit

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


class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width*0.1, y: size.height*0.5)
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence(
                [SKAction.runBlock(addMonster),
                SKAction.waitForDuration(0.2)]
            )
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
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
    

    
    
    
}
