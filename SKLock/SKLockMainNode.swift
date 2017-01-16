//
//  SKLockMainNode.swift
//  SKLockSample
//
//  Created by Martin Walsh on 15/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import SpriteKit

class SKLockMainNode: SKReferenceNode {

    var auth0Logo: SKSpriteNode!
    var socialFBButton: SKLockButtonNode!
    var socialTwitterButton: SKSpriteNode!

    override func didLoad(_ node: SKNode?) {
        auth0Logo = childNode(withName: "//auth0_logo") as! SKSpriteNode
        socialFBButton = childNode(withName: "//social_facebook") as! SKLockButtonNode
        socialTwitterButton = childNode(withName: "//social_twitter") as! SKSpriteNode

        socialFBButton.selectedHandler = {
            SKLock.sharedInstance.auth() {
                self.animateOut()
            }
        }

        animateIn()
        self.alpha = 0

        isUserInteractionEnabled = true
    }

    func animateIn() {
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.2)
        run(actionFadeIn)
    }

    func animateOut() {
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.2)
        let actionRemove   = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([actionFadeOut,actionRemove])
        run(actionSequence)
    }

    func addPhysics() {
        if let physicsBodyA = auth0Logo.physicsBody, let physicsBodyB = socialFBButton.physicsBody, let physicsBodyC = socialTwitterButton.physicsBody {
            let springJointA = SKPhysicsJointSpring.joint(withBodyA: physicsBodyA, bodyB: physicsBodyB, anchorA: auth0Logo.position, anchorB: socialFBButton.position)
            springJointA.frequency = 0.9
            let springJointB = SKPhysicsJointSpring.joint(withBodyA: physicsBodyA, bodyB: physicsBodyC, anchorA: auth0Logo.position, anchorB: socialTwitterButton.position)
            springJointB.frequency = 0.9
            self.scene?.physicsWorld.add(springJointA)
            self.scene?.physicsWorld.add(springJointB)
        }

    }
}
