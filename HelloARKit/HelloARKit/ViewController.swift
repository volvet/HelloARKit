//
//  ViewController.swift
//  HelloARKit
//
//  Created by Volvet Zhang on 2017/7/18.
//  Copyright © 2017年 Volvet Zhang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


let CollisionCategoryBottom : NSInteger = 1 << 0
let CollisionCategoryCube : NSInteger   = 1 << 1

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes =  Dictionary<UUID, PlaneEx>()
    var boxes : [SCNNode]  = []
    
    func setupScene() {
        self.sceneView.delegate = self
        let scene = SCNScene()
        self.sceneView.scene = scene
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        //self.sceneView.scene.physicsWorld.gravity = SCNVector3Make(0, -9.8, 0)
        
        self.setupBottomPlane()
    }
    
    func setupSession() {
        let configuration = ARWorldTrackingSessionConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        self.sceneView.session.run(configuration)
    }
    
    func setupRecognizer() {
        let tagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom))
        
        //let recognizer = UITapGestureRecognizer(target: self, action: "handleTapFrom:")
        tagGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tagGestureRecognizer)
        
        let explosionGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHoldFrom))
        explosionGestureRecognizer.minimumPressDuration = 0.5
        self.sceneView.addGestureRecognizer(explosionGestureRecognizer)
        
        let hidePlanesGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHidePlaneFrom))
        hidePlanesGestureRecognizer.minimumPressDuration = 1
        hidePlanesGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(hidePlanesGestureRecognizer)
    }
    
    func setupBottomPlane() {
        let bottomPlane = SCNBox(width: 1000, height: 0.5, length: 1000, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        bottomPlane.materials = [material]
        let bottomNode = SCNNode(geometry: bottomPlane)
        bottomNode.position = SCNVector3Make(0, -10, 0)
        bottomNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: bottomPlane, options: nil))
        bottomNode.physicsBody?.categoryBitMask = CollisionCategoryBottom
        bottomNode.physicsBody?.contactTestBitMask = CollisionCategoryCube
        
        self.sceneView.scene.rootNode.addChildNode(bottomNode)
        self.sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    @objc func handleTapFrom(recoginizer : UITapGestureRecognizer) {
        //NSLog("detect tap")
        let tapPoint = recoginizer.location(in: self.sceneView)
        let results = self.sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
        
        if results.count == 0 {
            return
        }
        
        let hitResult = results.first
        self.insertGeometry(hitResult: hitResult!)
    }
    
    @objc func handleHoldFrom(recognizer : UILongPressGestureRecognizer) {
        NSLog("detect hold")
    }
    
    @objc func handleHidePlaneFrom(recognizer : UILongPressGestureRecognizer) {
        NSLog("detect hide plane")
    }
    
    func insertGeometry(hitResult : ARHitTestResult) {
        NSLog("insert box")
        
        let dimension = 0.1
        let cube = SCNBox(width: CGFloat(dimension), height: CGFloat(dimension), length: CGFloat(dimension), chamferRadius: 0)
        let node = SCNNode(geometry: cube)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = 4.0
        node.physicsBody?.categoryBitMask = CollisionCategoryCube
        let insertYOffset : Float = 0.5
        node.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + insertYOffset, hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(node)
        self.boxes.append(node)
    }
    
    func explode(hitResult : ARHitTestResult) {
        //let explosionOffset : Float = 0.1
        //let position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + explosionOffset, hitResult.worldTransform.columns.3.z)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        setupScene()
        
        setupRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        NSLog("contack begin: nodeA.mask is %d, nodeB.mask is %d", contact.nodeA.categoryBitMask, contact.nodeB.categoryBitMask)
        
        let contactMask = contact.nodeA.categoryBitMask | contact.nodeB.categoryBitMask
        
        if contactMask == CollisionCategoryBottom | CollisionCategoryCube {
            if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategoryBottom {
                contact.nodeB.removeFromParentNode()
            } else {
                contact.nodeA.removeFromParentNode()
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    /*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchar = anchor as? ARPlaneAnchor {
            NSLog("didAdd SCNNode")
            let plane = PlaneEx(anchor: planeAnchar, isHidden: false)
            self.planes[anchor.identifier] = plane
            node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchar = anchor as? ARPlaneAnchor {
            //NSLog("didUpdate SCNNode")
            var plane : PlaneEx?
            plane = self.planes[anchor.identifier]
            
            plane?.update(PlanAnchor: planeAnchar)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchar = anchor as? ARPlaneAnchor {
            NSLog("didRemove SCNNode")
            self.planes.removeValue(forKey: planeAnchar.identifier)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
