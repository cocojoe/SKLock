//
//  SKLock.swift
//  SKLockSample
//
//  Created by Martin Walsh on 14/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation
import SpriteKit

public class SKLock {

    static let sharedInstance = SKLock()

    public static func present(withNode node: SKNode) {
        let bundle = Bundle(for: self)
        guard let resource = bundle.path(forResource: "SKSelectionScene", ofType: "sks") else {
            assertionFailure("Resource: SKSelectionScene not found.")
            return
        }
        let selectionScene = SKReferenceNode(url: URL(fileURLWithPath: resource))
        node.addChild(selectionScene)

    }

}
