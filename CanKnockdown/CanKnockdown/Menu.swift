//
//  Menu.swift
//  CanKnockdown
//
//  Created by Iokepa Lapera on 4/27/19.
//  Copyright © 2019 Iokepa Lapera. All rights reserved.
//

import Foundation
import SpriteKit


class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    override func didMove(to view: SKView) {
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
