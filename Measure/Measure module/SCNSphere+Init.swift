//
//  SCNSphere+Init.swift
//  Measure
//
//  Created by Bhat, Adithya H (external - Project) on 23/01/19.
//  Copyright © 2019 Bhat, Adithya H (external - Project). All rights reserved.
//

import Foundation
import SceneKit

extension SCNSphere {
    convenience init(color: UIColor, radius: CGFloat) {
        self.init(radius: radius)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        materials = [material]
    }
}
