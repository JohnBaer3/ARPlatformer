//
//  GameScene.swift
//  WaluigiAR
//
//  Created by John Baer on 11/14/18.
//  Copyright © 2018 John Baer. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import UIKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    var placeData = [CGPoint]()
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
//Added code
    var black = SKSpriteNode()
    var buttonR: SKNode! = nil
    var buttonL: SKNode! = nil
    var buttonRightDown: Bool = false
    var buttonLeftDown: Bool = false
    
    override func didMove(to view: SKView) {
        createScene()
        
//ADDED CODE
        buttonR = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        buttonR.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-250);
        self.addChild(buttonR)
        buttonL = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 100, height: 44))
        buttonL.position = CGPoint(x:self.frame.midX-50, y:self.frame.midY-250);
        self.addChild(buttonL)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()

//Animating the bird's flapping animation
            self.bird.run(repeatActionBird)
            
//Function to spawn a pair of walls
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            
//Block of code here infinitely spawns a pair of walls, waits a delay, then spawns a pair again
//            let delay = SKAction.wait(forDuration: 1.5)
//            let SpawnDelay = SKAction.sequence([spawn, delay])
//            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
//            self.run(spawnDelayForever)
//            let distance = CGFloat(self.frame.width + wallPair.frame.width)
//            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
//            let removePillars = SKAction.removeFromParent()
//            moveAndRemove = SKAction.sequence([movePillars, removePillars])

            
//ADDED CODE
            self.run(spawn)
            
            
//Bird acceleteration for first tap
//            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
        } else {
//Bird acceleteration when tapped
//            if isDied == false {
//                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
//            }
        }
        
//Functions for pause and highscore
        for touch in touches{
            let location = touch.location(in: self)
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
                
                
                if buttonR.contains(location) {
                    buttonRightDown = true
                }else if(buttonL.contains(location)){
                    buttonLeftDown = true
                }else{
                    if isDied == false {
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                    }
                }
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if buttonR.contains(location) {
                bird.physicsBody?.velocity.dx = 0
                buttonRightDown = false
            }else if(buttonL.contains(location)){
                bird.physicsBody?.velocity.dx = 0
                buttonLeftDown = false
            }
                
        }
        
        
    }
    
    
    
    
//Function for making background scrolling
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
//CHANGED CODE
//                enumerateChildNodes(withName: "background", using: ({
//                    (node, error) in
//                    let bg = node as! SKSpriteNode
//                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
//                    if bg.position.x <= -bg.size.width {
//                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
//                    }
//                }))
            }
        }
        
//ADDED CODE
        if(buttonRightDown){
            bird.physicsBody?.velocity.dx = 100
        }else if(buttonLeftDown){
            bird.physicsBody?.velocity.dx = -100
        }
    }
    
    
    
    
    
    
//ADDED CODE
    func catchData(placeDatar: [CGPoint]){
        placeData = placeDatar

        
        //Problem is: i isn't changing at all
        //Have to get the skipping to work properly
        var counter: Int = 0
        for var i in 0...placeData.count-1{
            
            
            self.black = createBlack(xPos: Int(placeData[i].x), yPos: Int(placeData[i].y), xWidth: 5)
            self.addChild(black)

            
//            if(counter > 0){
//                counter -= 1
//                continue
//            }else if(counter == 0){
//                var width:Int = 5;
//                while(i + counter < placeData.count - 2 && placeData[i].y == placeData[i+counter+1].y){
//                    width += 5;
//                    counter += 1;
//                    if(placeData[i] != placeData[i+counter]){
//                        print(placeData[i].x, " ", placeData[i+counter].x, " ", placeData[i].y, " ", placeData[i+counter].y)
//                    }
//                }
//                self.black = createBlack(xPos: Int(placeData[i].x), yPos: Int(placeData[i].y), xWidth: width)
//                self.addChild(black)
//                print(counter)
//            }
        }
    }
    
    
    
    
    
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        
//ADDED CODE
        self.physicsBody?.collisionBitMask = CollisionBitMask.blackCategory
        
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        
//This is for scrolling background, instantiate's its position
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        
        
        self.bird = createBird()
        self.addChild(bird)
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        

//CHANGED CODE HERE
//if the bird collides with pillars or grounds, then stops all actions
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.blackCategory{
            
//ADDED CODE
            //firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.blackCategory
            
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
//                node.speed = 0
//                self.removeAllActions()
            }))
            if isDied == false{
//                isDied = true
//                createRestartBtn()
//                pauseBtn.removeFromParent()
//                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    

    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
    
}
