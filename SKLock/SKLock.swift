//
//  SKLock.swift
//  SKLockSample
//
//  Created by Martin Walsh on 14/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation
import SpriteKit
import Auth0

public class SKLock: NSObject {
    public static let sharedInstance = SKLock()

    private(set) var webAuth: WebAuth
    private(set) var authentication: Authentication
    private(set) var onSuccess: (Profile?) -> () = { _ in }

    override convenience init() {
        self.init(authentication: Auth0.authentication(), webAuth: Auth0.webAuth())
    }

    required public init(authentication: Authentication, webAuth: WebAuth) {
        self.authentication = authentication
        self.webAuth = webAuth
    }

    public func present(withNode node: SKNode, callback: @escaping (Profile?) -> ()) {
        guard node.childNode(withName: "\\SKLockMainScene") == nil else { return }
        let bundle = Bundle(for: SKLock.classForCoder())
        guard let resource = bundle.path(forResource: "SKLockMainScene", ofType: "sks") else {
            assertionFailure("Resource: SKLockMainScene not found.")
            return
        }
        let selectionScene = SKLockMainNode(url: URL(fileURLWithPath: resource))
        selectionScene.name = "SKLockMainScene"
        node.addChild(selectionScene)
        selectionScene.addPhysics() // Post Step
        self.onSuccess = callback
    }

    public func auth(callback: @escaping () -> () ) {
        let auth = self.webAuth.connection("facebook")
        auth
            .start { result in
                switch result {
                case .success(let credentials):
                    self.authentication.userInfo(token: credentials.accessToken!)
                        .start { result in
                            switch result {
                            case .success(let profile):
                                self.onSuccess(profile)
                            default:
                                self.onSuccess(nil)
                            }
                    }
                case .failure(WebAuthError.userCancelled):
                    self.onSuccess(nil)
                case .failure:
                    self.onSuccess(nil)
                }
                return callback()
        }
        
    }
    
    public func resumeAuth(_ url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        return Auth0.resumeAuth(url, options: options)
    }
    
}
