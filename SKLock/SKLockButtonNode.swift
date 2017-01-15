//
//  SKLockButtonNode.swift
//  SKLockSample
//
//  Created by Martin Walsh on 15/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import SpriteKit

enum ButtonState {
    case active
    case selected
    case hidden
}

class SKLockButtonNode: SKSpriteNode {

    var selectedHandler: () -> () = { _ in }

    var state: ButtonState = .active {
        didSet {
            switch state {
            case .active:
                self.isUserInteractionEnabled = true
                self.alpha = 1
                break
            case .selected:
                self.alpha = 0.7
                break
            case .hidden:
                self.isUserInteractionEnabled = false
                self.alpha = 0
                break
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .active
    }
}
