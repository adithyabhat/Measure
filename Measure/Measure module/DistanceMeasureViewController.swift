//
//  ViewController.swift
//  AMMeasure
//
//  Created by Bhat, Adithya H on 04/04/19.
//

import UIKit
import ARKit

class DistanceMeasureViewController: MeasureViewController {
    
    struct FloorRect {
        var length: CGFloat
        var breadth: CGFloat
        var area: CGFloat {
            get {
                return length * breadth
            }
        }
    }
    
    var distance: CGFloat = 0
    var distanceNodes = NSMutableArray()
    var lineNodes = NSMutableArray()
    
    var nodeColor = UIColor.white.withAlphaComponent(0.7)
    
    @IBOutlet weak var lengthLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    //MARK: - Private helper methods
    
    func clearScene() {
        removeNodes(fromNodeList: distanceNodes)
        removeNodes(fromNodeList: lineNodes)
    }
    
    private func resetMeasurement() {
        clearScene()
        distance = 0
    }
    
    
    //MARK: - IBActions
    
    @IBAction func addPoint(_ sender: UIButton) {
        
        let pointLocation = view.convert(screenCenterPoint, to: sceneView)
        guard let hitResultPosition = sceneView.hitResult(forPoint: pointLocation)  else {
            return
        }
        
        //To prevent multiple taps
        sender.isUserInteractionEnabled = false
        defer {
            sender.isUserInteractionEnabled = true
        }
        
        if distanceNodes.count >= 2 {
            resetMeasurement()
        }
        let nodes = distanceNodes
        
        let sphere = SCNSphere(color: nodeColor, radius: nodeRadius)
        let node = SCNNode(geometry: sphere)
        node.position = hitResultPosition
        sceneView.scene.rootNode.addChildNode(node)
    
        // Add the Sphere to the list.
        nodes.add(node)
        
        if nodes.count == 1 {
            
            //Add a realtime line
            let realTimeLine = LineNode(from: hitResultPosition,
                                        to: hitResultPosition,
                                        lineColor: nodeColor,
                                        lineWidth: lineWidth)
            realTimeLine.name = realTimeLineName
            realTimeLineNode = realTimeLine
            sceneView.scene.rootNode.addChildNode(realTimeLine)
            
        } else if nodes.count == 2 {
            let startNode = nodes[0] as! SCNNode
            let endNode = nodes[1]  as! SCNNode
            
            // Create a node line between the nodes
            let measureLine = LineNode(from: startNode.position,
                                       to: endNode.position,
                                       lineColor: nodeColor,
                                       lineWidth: lineWidth)
            sceneView.scene.rootNode.addChildNode(measureLine)
            lineNodes.add(measureLine)
            
            //Remove realtime line node
            realTimeLineNode?.removeFromParentNode()
            realTimeLineNode = nil
            
            distance = sceneView.distance(betweenPoints: startNode.position, point2: endNode.position)
            lengthLabel.text = String(format: "%.2fm", distance)
        }
    }
    
}

extension DistanceMeasureViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dotNodes = distanceNodes as! [SCNNode]
        if dotNodes.count > 0, let currentCameraPosition = self.sceneView.pointOfView {
            updateScaleFromCameraForNodes(dotNodes, fromPointOfView: currentCameraPosition)
        }
        
        //Update realtime line node
        if let realTimeLineNode = self.realTimeLineNode,
            let hitResultPosition = sceneView.hitResult(forPoint: screenCenterPoint),
            let startNode = distanceNodes.firstObject as? SCNNode {
            realTimeLineNode.updateNode(vectorA: startNode.position, vectorB: hitResultPosition, color: nil)
            
            let distance = sceneView.distance(betweenPoints: startNode.position, point2: hitResultPosition)
            DispatchQueue.main.async { [unowned self] in
                self.lengthLabel.text = String(format: "%.2fm", distance)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            break
        default:
            break
        }
    }
    
}
