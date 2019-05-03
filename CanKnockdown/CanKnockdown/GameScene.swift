//
//  GameScene.swift
//  CanKnockdown
//
//  Created by Iokepa Lapera on 4/25/19.
//  Copyright © 2019 Iokepa Lapera. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score: SKLabelNode!
    var ballsLeft: SKLabelNode!
    var cansLeft: SKLabelNode!
    
    var ball: SKSpriteNode!
    var nextB: SKSpriteNode!
    var Menu: SKSpriteNode!
    var ground: SKSpriteNode!
    var startButton: SKSpriteNode!
    
    var life: Int!
    var cans: Int!
        
    var touch1:CGPoint!
    var touch2:CGPoint!
    
    var timer: Timer!
    
    var counter:Double = 0.0        //for SKAction
    var time:Double = 0.0           //holds time
    var velocity:Double = 0.03      //velocity
    var startTime:Double = 0.0      //Start tiem
    
    var begin:Bool!                 //Start of round
    var start:Bool!                 //For touches functions
    var touchedAlready:Bool!        //tells when the ball has been moved already
    var addNextB: Bool!             //When to add "Next" button
    var succeed: Bool!              //tells if the player got all the cans off the table
    var done: Bool!                 //End of round
    
    var test:SKLabelNode?
    

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self        //This scene is in charge of contact
        
        //Sprite Nodes
        startButton = self.childNode(withName: "StartButton") as? SKSpriteNode
        score = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        ball = self.childNode(withName: "Ball") as? SKSpriteNode
        ground = self.childNode(withName: "Ground") as? SKSpriteNode
        Menu = SKSpriteNode(imageNamed: "MenuBut-1") as? SKSpriteNode
        
        cans = 3
        life = 5
        begin = false
        start = false
        addNextB = false
        touchedAlready = false
        succeed = false
        done = false
        
        updateBall()
        
        //tells the ground to report back what it collides with
        ground.physicsBody?.contactTestBitMask = ground.physicsBody?.collisionBitMask ?? 0
        
        cansLeft = SKLabelNode(fontNamed: "Arial")
        cansLeft.fontSize = 32
        cansLeft.text = "Cans left: \(cans ?? 3)"
        cansLeft.position = CGPoint(x: -250, y: 161)
        addChild(cansLeft)
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Checks if cans are knocked off
        if cans == 0 && succeed == false{
            succeed = true
            end()
        }
        
        //Removes Next Button if all cans are knocked off mid round
        if succeed == true{
            nextB?.removeFromParent()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        //if round over, do this
        if done == true{
            //checks if Menu button is touched
            if let location = touch?.location(in: self){
                let nodesArray = self.nodes(at: location)
                
                if(nodesArray.first?.name == "Menu" ){
                    toMenu()                                //adds a menu button after round is over
                }
            }
        }else{
        
                //if Beginning of round
            if begin == false{
                if let location = touch?.location(in: self){
                    let nodesArray = self.nodes(at: location)
        
                    if(nodesArray.first?.name == "StartButton" ){
                        begin = true
                        startButton.removeFromParent()
                        ball.position = CGPoint(x: -256, y: 21)
                    }
                
                }
            }else if begin == true && touchedAlready == false{
                start = true
                ball.physicsBody?.isDynamic = false
                ball.physicsBody?.affectedByGravity = false
                touch1 = touch?.location(in: self)
                touch2 = touch1
                startTime = 0.0
                counter = 0.0
                countup()
            }
            if touchedAlready == true{
                //if Next button is clicked
                if let location = touch?.location(in: self){
                    let nodesArray = self.nodes(at: location)
                    if nodesArray.first?.name == "Next"{
                        Restart()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if begin == true && start == true && touchedAlready == false{
            for touch in (touches){
                let location = touch.location(in: self)
                touch2 = location           //gets lates coords of touch
                }
            }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //uses CountUp function
        if begin == true && start == true && touchedAlready == false{
            //calculate amount of force to put on the ball (((point2 - point1)/time) * velocity)
            let force = CGVector(dx: ((touch2.x - touch1.x)/CGFloat(time) * CGFloat(0.02)), dy: (touch2.y - touch1.y)/CGFloat(time) * CGFloat(0.02))
        
            self.removeAllActions()
            ball.physicsBody?.isDynamic = true              //adds to physic body of ball
            ball.physicsBody?.affectedByGravity = true      //after touch
            ball.physicsBody?.applyImpulse(force)           //
            life -= 1
            updateBall()
            touchedAlready = true
        }
        //checks if ball was thrown already
        if touchedAlready == true && addNextB == false && life != 0 && succeed == false{
            nextB = SKSpriteNode(imageNamed: "NextBall")
            nextB.position = CGPoint(x: 0, y: 161)
            nextB.scale(to: startButton.size)
            nextB.name = "Next"
            addChild(nextB)
            addNextB = true
        }
        if life == 0 || cans == 0 && done == false{
            end()
            nextB?.removeFromParent()
        }
    }
    
    //what to do at end of round
    func end(){
        if life == 0 && cans != 0{
            let done = SKLabelNode(fontNamed: "Arial")
            done.fontColor = UIColor.red
            done.text = "Failed!"
            done.position = CGPoint(x: 0, y: 0)
            done.fontSize = 32
            addChild(done)
        } else if life != 0 && cans == 0{
            succeed = true
            let done = SKLabelNode(fontNamed: "Arial")
            done.fontColor = UIColor.green
            done.text = "Good Job!"
            done.position = CGPoint(x: 0, y: 0)
            done.fontSize = 32
            addChild(done)
        }
        if done == false{
            done = true
            addMenu()
        }
    }
    
    //timer SKAction used for "impact" on the ball
    func countup(){
        print("start Count \(counter)")
        let wait:SKAction = SKAction.wait(forDuration: 0.01)
        let finishTimer:SKAction = SKAction.run {
            
            self.time = self.counter
            
            self.counter += 0.01
        
            self.countup()
            print("run")
        }
        
        let seq:SKAction = SKAction.sequence([wait, finishTimer])
        self.run(seq)
    }
    
    //adds a Next Button
    func addNext(){
        addChild(nextB)
        nextB.position = CGPoint(x: 0, y: 160)
        let size = CGSize(width: 0.2, height: 0.2)
        nextB.scale(to: size)
        nextB.name = "Next"
    }
    
    //adds a Menu button
    func addMenu(){
            done = true
            Menu.position = CGPoint(x: 0, y: -(frame.height/3))
            Menu.name = "Menu"
            addChild(Menu)
    }
    
    //resets ball physics and bools
    func Restart(){
        ball.physicsBody?.isDynamic = false
        ball.physicsBody?.affectedByGravity = false
        ball.position = CGPoint(x: -256, y: 21)
        
        start = false
        addNextB = false
        touchedAlready = false
        nextB.removeFromParent()
        
    }
    
    //updates amount of cans left text
    func updateCans(){
        cans -= 1
        cansLeft?.text = "Cans Left: \(cans ?? 0)"
    }
    
    //updates amount of ballse left
    func updateBall(){
        ballsLeft?.removeFromParent()
        ballsLeft = SKLabelNode(fontNamed: "Arial")
        ballsLeft?.text = "Balls Left: \(life!)"
        ballsLeft?.horizontalAlignmentMode = .center
        ballsLeft?.position = CGPoint(x: 270, y: 161)
        addChild(ballsLeft!)
    }
    
    //To go to the menu screen
    func toMenu(){
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        let Menu = GameScene(fileNamed: "MenuScene")!
        Menu.scaleMode = .aspectFill
        self.view?.presentScene(Menu, transition: transition)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Can1" || contact.bodyA.node?.name == "Can2" || contact.bodyA.node?.name == "Can3"{
            updateCans()
            contact.bodyA.node?.removeFromParent()
        }else if contact.bodyB.node?.name == "Can1" || contact.bodyB.node?.name == "Can2" || contact.bodyB.node?.name == "Can3"{
            updateCans()
            contact.bodyB.node?.removeFromParent()
        }
        
    }
    
}
