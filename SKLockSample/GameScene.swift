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

enum GameState {
    case pending
    case running
    case ended
}

class GameScene: SKScene {
    
    private var loginButton : SKLabelNode!
    private var headerTitle: SKLabelNode!
    private var profileNode: SKSpriteNode!

    private var state: GameState = .pending
    private var counter: CGFloat = 0

    override func didMove(to view: SKView) {
        self.loginButton = self.childNode(withName: "//loginButton") as! SKLabelNode
        self.headerTitle = self.childNode(withName: "//headerTitle") as! SKLabelNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: self)
            if loginButton.contains(position) {
                loginButton.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
                SKLock.sharedInstance.present(withNode: self) { [unowned self] profile in
                    guard let profile = profile else { return }

                    let pictureURL: URL = profile.pictureURL
                    let name = profile.name.components(separatedBy: " ").first

                    loadImageAsync(imageURL: pictureURL) { [unowned self] image, error in
                        guard let image = image, error == nil else { return }
                        let imageTexture = SKTexture(image: image)
                        self.profileNode = SKSpriteNode.init(texture: imageTexture)

                        self.state = .running
                        self.headerTitle.text = name
                        self.loginButton.removeFromParent()

                        self.spawnNode()
                    }
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard self.state == .running else { return }
        counter += 1
        if(counter >= 25) {
            counter = 0
            spawnNode()
        }
    }

    func spawnNode() {
        guard let node = self.profileNode.copy() as? SKSpriteNode else { return }
        let randomNum:CGFloat = CGFloat(arc4random_uniform(UInt32(self.size.width)))
        node.position = CGPoint(x: randomNum, y: -node.size.height)
        print(node.position)
        node.physicsBody = SKPhysicsBody.init(rectangleOf: node.size)
        node.physicsBody?.mass = 0.5
        addChild(node)
    }

}
