//
//  SKLockUtil.swift
//  SKLockSample
//
//  Created by Martin Walsh on 15/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

func loadImageAsync(imageURL: URL, completionHandler: @escaping (UIImage?, Error?) -> ()) {
    let request = URLRequest(url: imageURL)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard data != nil else {
            print("No image data found: \(error)")
            return
        }
        do {
            completionHandler(UIImage(data: data!), error)
        }
    }
    task.resume()
}
