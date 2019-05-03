//
//  EndlessMode.swift
//  CanKnockdown
//
//  Created by Iokepa Lapera on 5/2/19.
//  Copyright © 2019 Iokepa Lapera. All rights reserved.
//

import UIKit
import SpriteKit

class EndlessMode: SKScene {
    var can: SKSpriteNode!
    var can2: SKSpriteNode!
    var can3: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var canLoc1:SKNode!
    var canLoc2: SKNode!
    var canLoc3: SKNode!
    
    var scoreLabel: SKLabelNode!
    var cansLabel: SKLabelNode!
    
    var score:Int!{
        didSet{
            scoreLabel?.text = "Score: \(score ?? 0)"
        }
    }
    var cansLeft:Int!
    
    override func didMove(to view: SKView){
        scene?.scaleMode = SKSceneScaleMode.resizeFill
        
        canLoc1 = self.childNode(withName: "CanLoc1")
        canLoc2 = self.childNode(withName: "CanLoc2")
        canLoc3 = self.childNode(withName: "CanLoc3")
        
        can = SKSpriteNode(imageNamed: "can")
        can2 = SKSpriteNode(imageNamed: "can")
        can3 = SKSpriteNode(imageNamed: "can")

        
        cansLeft = 3
        score = 0
        
        createCans()
        
        ground = self.childNode(withName: "Ground") as? SKSpriteNode
    }
    
    func createCans(){
        can = SKSpriteNode(imageNamed: "can")
        can.scale(to: CGSize(width: 0.5, height: 0.5))
        can.physicsBody?.isDynamic = true
        can.physicsBody?.affectedByGravity = true
        can.position = canLoc1.position
        
        can2.scale(to: CGSize(width: 0.5, height: 0.5))
        can2.physicsBody?.isDynamic = true
        can2.physicsBody?.affectedByGravity = true
        can2.position = canLoc2.position
        
        
        can3.scale(to: CGSize(width: 0.5, height: 0.5))
        can3.physicsBody?.isDynamic = true
        can3.physicsBody?.affectedByGravity = true
        can3.position = canLoc3.position
        
        addChild(can)
        addChild(can2)
        addChild(can3)
    }
}
