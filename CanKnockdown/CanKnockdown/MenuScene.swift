//
//  MenuScene.swift
//  CanKnockdown
//
//  Created by Iokepa Lapera on 4/28/19.
//  Copyright © 2019 Iokepa Lapera. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var PlayButton:SKSpriteNode!
    var Info:SKSpriteNode!
    var Endless: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        PlayButton = self.childNode(withName: "PlayButton") as! SKSpriteNode

        
        Info = self.childNode(withName: "Info") as! SKSpriteNode
        Info.texture = SKTexture(imageNamed: "info")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if(nodesArray.first?.name == "PlayButton" ){
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let gameScene = GameScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: transition)
            }else if (nodesArray.first?.name == "Info"){
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                let infoScene = GameScene(fileNamed:"InfoScene")!
                infoScene.scaleMode = .aspectFill
                self.view?.presentScene(infoScene, transition: transition)
            }
        }
        
    }
    
}
