//
//  GameScene.swift
//  GameExample
//
//  Created by Bob Pascazio on 11/4/15.
//  Copyright (c) 2015 NYCDA. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width*0.1, y: size.height*0.5)
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence(
                [SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)]
            )
        ))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
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
