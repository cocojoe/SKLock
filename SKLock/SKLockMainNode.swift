//
//  SKLockMainNode.swift
//  SKLockSample
//
//  Created by Martin Walsh on 15/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import SpriteKit

class SKLockMainNode: SKReferenceNode {

    var socialButton: SKLockButtonNode!

    override func didLoad(_ node: SKNode?) {
        socialButton = childNode(withName: "//social_facebook") as! SKLockButtonNode

        socialButton.selectedHandler = {
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
}
