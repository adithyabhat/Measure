//
//  LineNode.swift
//  Measure
//
//  Created by Bhat, Adithya H (external - Project) on 06/02/19.
//  Copyright © 2019 Bhat, Adithya H (external - Project). All rights reserved.
//

import UIKit
import SceneKit

class LineNode: SCNNode {
    
    let lineThickness = CGFloat(0.001)
    let radius = CGFloat(0.1)
    var lineGeometry: SCNGeometry?
    
    init(from vectorA: SCNVector3, to vectorB: SCNVector3, lineColor color: UIColor, lineWidth width: CGFloat) {
        super.init()
        
        self.position = vectorA
        
        let nodeZAlign = SCNNode()
        nodeZAlign.eulerAngles.x = Float.pi/2
        
        let height = self.distance(from: vectorA, to: vectorB)
        let box = SCNBox(width: width, height: height, length: lineThickness, chamferRadius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        box.materials = [material]
        lineGeometry = box
        
        let nodeLine = SCNNode(geometry: box)
        nodeLine.position.y = Float(-height/2) + 0.001
        nodeZAlign.addChildNode(nodeLine)
        
        self.addChildNode(nodeZAlign)
        
        let orientationNode = SCNNode()
        orientationNode.position = vectorB
        self.constraints = [SCNLookAtConstraint(target: orientationNode)]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distance(from vectorA: SCNVector3, to vectorB: SCNVector3)-> CGFloat {
        return
            CGFloat (sqrt(
                (vectorA.x - vectorB.x) * (vectorA.x - vectorB.x) +
                    (vectorA.y - vectorB.y) * (vectorA.y - vectorB.y) +
                    (vectorA.z - vectorB.z) * (vectorA.z - vectorB.z)))
    }
}
