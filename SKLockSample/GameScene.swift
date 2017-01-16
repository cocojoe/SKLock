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
    case setup
    case running
}

class GameScene: SKScene {
    
    private var loginButton : SKLabelNode!
    private var headerTitle: SKLabelNode!
    private var profileNode: [SKSpriteNode] = []

    private var state: GameState = .setup
    private var spawnCounter: CGFloat = 0
    private var imageCounter: CGFloat = 0

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

            if state == .setup, loginButton.contains(position) {
                loginButton.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
                SKLock.sharedInstance.present(withNode: self) { [unowned self] profile in
                    guard let profile = profile else { return }

                    let id: String  = profile.id.components(separatedBy: "|").last!
                    let name: String = profile.name.components(separatedBy: " ").first!
                    self.addProfilePicture(withId: id) {
                        self.state = .running
                        self.headerTitle.text = name
                        self.loginButton.removeFromParent()
                        self.spawnNode()
                    }
                }
            } else {
                for node in self.nodes(at: position) {
                    node.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random()*1000, dy: CGFloat.random()*1000))
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard self.state == .running else { return }
        spawnCounter += 1
        if(spawnCounter >= 15) {
            spawnCounter = 0
            spawnNode()
        }
    }

    func spawnNode() {
        guard let node = self.profileNode.first?.copy() as? SKSpriteNode else { return }
        let randomNum:CGFloat = CGFloat(arc4random_uniform(UInt32(self.size.width)))
        node.position = CGPoint(x: randomNum, y: self.size.height + node.size.height)
        node.setScale(CGFloat.random(min: 0.15, max: 0.50))
        node.colorBlendFactor = 1.0
        node.color = UIColor(red: CGFloat.random(min: 0.5, max: 1.0), green:  CGFloat.random(min: 0.5, max: 1.0), blue:  CGFloat.random(min: 0.5, max: 1.0), alpha: 1.0)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.mass = 0.25
        addChild(node)
    }

    func addProfilePicture(withId id: String, callback: ( () -> () )? ) {
        let pictureURL = URL(string: "https://graph.facebook.com/v2.8/\(id)/picture?height=100")
        loadImageAsync(imageURL: pictureURL!) { [unowned self] image, error in
            guard let image = image, error == nil else { return }
            let imageTexture = SKTexture(image: image)
            let profileNode = SKSpriteNode(texture: imageTexture)
            self.profileNode.append(profileNode)
            if let callback = callback {
                callback()
            }
        }
    }
}
