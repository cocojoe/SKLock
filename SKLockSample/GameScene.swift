//
//  GameScene.swift
//  SKLockSample
//
//  Created by Martin Walsh on 14/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import SpriteKit
import GameplayKit
import SKLock

class GameScene: SKScene {
    
    private var loginButton : SKLabelNode!

    override func didMove(to view: SKView) {

        self.loginButton = self.childNode(withName: "//loginButton") as! SKLabelNode
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if loginButton.contains(pos) {
            loginButton.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            SKLock.present(withNode: self)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
