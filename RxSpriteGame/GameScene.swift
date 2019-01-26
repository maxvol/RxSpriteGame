//
//  GameScene.swift
//  RxSpriteGame
//
//  Created by Maxim Volgin on 25/01/2019.
//  Copyright © 2019 Maxim Volgin. All rights reserved.
//

import SpriteKit
import GameplayKit
// CUSTOM CODE ->
import os.log
import RxSwift
import RxSpriteKit
// CUSTOM CODE <-

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // CUSTOM CODE ->
    private let disposeBag = DisposeBag()
    private let spinnyCategory: UInt32 = 1 << 0
    private let labelCategory: UInt32 = 1 << 1
    // CUSTOM CODE <-
    
    override func sceneDidLoad() {
        
        // CUSTOM CODE ->
        self
            .rx
            .update
            .subscribe { [unowned self] event in
                switch event {
                case .next(let update):
                    let currentTime = update.currentTime
                    // Called before each frame is rendered
                    
                    // Initialize _lastUpdateTime if it has not already been
                    if (self.lastUpdateTime == 0) {
                        self.lastUpdateTime = currentTime
                    }
                    
                    // Calculate time since last update
                    let dt = currentTime - self.lastUpdateTime
                    
                    // Update entities
                    for entity in self.entities {
                        entity.update(deltaTime: dt)
                    }
                    
                    self.lastUpdateTime = currentTime
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        // OLD SCHOOL:
        // self.physicsWorld.contactDelegate = self
        self
            .physicsWorld
            .rx
            .didBeginContact
            .subscribe { event in
                switch event {
                case .next(let didBeginContact):
                    os_log("didBeginContact: %@", log: Log.sk, type: .debug, didBeginContact)
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        self
            .physicsWorld
            .rx
            .didEndContact
            .subscribe { event in
                switch event {
                case .next(let didBeginContact):
                    os_log("didEndContact: %@", log: Log.sk, type: .debug, didBeginContact)
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        // CUSTOM CODE <-
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            // CUSTOM CODE ->
            label.physicsBody = SKPhysicsBody(rectangleOf: label.frame.size)
            label.physicsBody?.isDynamic = true
            label.physicsBody?.affectedByGravity = false
            label.physicsBody?.usesPreciseCollisionDetection = true
            label.physicsBody?.categoryBitMask = self.labelCategory
            label.physicsBody?.collisionBitMask = self.spinnyCategory
            label.physicsBody?.contactTestBitMask = self.spinnyCategory
            // CUSTOM CODE <-
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            // CUSTOM CODE ->
            spinnyNode.physicsBody = SKPhysicsBody(rectangleOf: spinnyNode.frame.size)
            spinnyNode.physicsBody?.isDynamic = true
            spinnyNode.physicsBody?.affectedByGravity = false
            spinnyNode.physicsBody?.usesPreciseCollisionDetection = true
            spinnyNode.physicsBody?.categoryBitMask = self.spinnyCategory
            spinnyNode.physicsBody?.collisionBitMask = self.labelCategory | self.spinnyCategory
            spinnyNode.physicsBody?.contactTestBitMask = self.labelCategory | self.spinnyCategory
            // CUSTOM CODE <-
        }
    }    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
// MARK: - OLD SCHOOL
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//
//        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//
//        self.lastUpdateTime = currentTime
//    }
}
