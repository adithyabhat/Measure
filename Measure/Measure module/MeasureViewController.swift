//
//  MeasureViewController.swift
//  AMMeasure
//
//  Created by Bhat, Adithya H on 04/04/19.
//

import UIKit
import ARKit

class MeasureViewController: UIViewController {

    let lineWidth = CGFloat(0.003)
    let nodeRadius = CGFloat(0.015)
    let realTimeLineName = "realTimeLine"

    var realTimeLineNode: LineNode?
    
    @IBOutlet weak var centerPointImageView: UIImageView!
    @IBOutlet weak var sceneView: MeasureSCNView!
    
    lazy var screenCenterPoint: CGPoint = {
        return centerPointImageView.center
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.pause()
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Helper methods
    
    func removeNodes(fromNodeList nodes: NSMutableArray) {
        for node in nodes {
            if let node = node as? SCNNode {
                node.removeFromParentNode()
                nodes.remove(node)
            }
        }
    }
    
    func updateScaleFromCameraForNodes(_ nodes: [SCNNode], fromPointOfView pointOfView: SCNNode){
        
        nodes.forEach { (node) in
            
            //1. Get The Current Position Of The Node
            let positionOfNode = SCNVector3ToGLKVector3(node.worldPosition)
            
            //2. Get The Current Position Of The Camera
            let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.worldPosition)
            
            //3. Calculate The Distance From The Node To The Camera
            let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
            
            //4. Animate Their Scaling & Set Their Scale Based On Their Distance From The Camera
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            switch distanceBetweenNodeAndCamera {
            case 0 ... 0.5:
                node.simdScale = simd_float3(0.25, 0.25, 0.25)
            case 0.5 ... 1.5:
                node.simdScale = simd_float3(0.5, 0.5, 0.5)
            case 1.5 ... 2.5:
                node.simdScale = simd_float3(1, 1, 1)
            case 2.5 ... 3:
                node.simdScale = simd_float3(1.5, 1.5, 1.5)
            case 3 ... 3.5:
                node.simdScale = simd_float3(2, 2, 2)
            case 3.5 ... 5:
                node.simdScale = simd_float3(2.5, 2.5, 2.5)
            default:
                node.simdScale = simd_float3(3, 3, 3)
            }
            SCNTransaction.commit()
        }
        
    }
}
