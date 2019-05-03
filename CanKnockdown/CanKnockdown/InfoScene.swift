//
//  InfoScene.swift
//  CanKnockdown
//
//  Created by Iokepa Lapera on 4/28/19.
//  Copyright © 2019 Iokepa Lapera. All rights reserved.
//

import SpriteKit

class InfoScene: SKScene {
    
    var BackButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        BackButton = self.childNode(withName: "BackButton") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if(nodesArray.first?.name == "BackButton" ){
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let Menu = GameScene(fileNamed: "MenuScene")!
                Menu.scaleMode = .aspectFill
                self.view?.presentScene(Menu, transition: transition)
            }
    }
    
}
}
