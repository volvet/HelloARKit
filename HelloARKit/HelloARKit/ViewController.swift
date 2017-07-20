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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes =  Dictionary<UUID, Plane>()
    
    
    func setupScene() {
        self.sceneView.delegate = self
        let scene = SCNScene()
        self.sceneView.scene = scene
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
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
        tagGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(tagGestureRecognizer)
        
        let explosionGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHoldFrom))
        explosionGestureRecognizer.minimumPressDuration = 0.5
        self.sceneView.addGestureRecognizer(explosionGestureRecognizer)
        
        let hidePlanesGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHidePlaneFrom))
        hidePlanesGestureRecognizer.minimumPressDuration = 1
        hidePlanesGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(hidePlanesGestureRecognizer)
    }
    
    @objc func handleTapFrom(recoginizer : UITapGestureRecognizer) {
        NSLog("detect tap")
    }
    
    @objc func handleHoldFrom(recognizer : UILongPressGestureRecognizer) {
        NSLog("detect hold")
    }
    
    @objc func handleHidePlaneFrom(recognizer : UILongPressGestureRecognizer) {
        NSLog("detect hide plane")
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

    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    /*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchar = anchor as? ARPlaneAnchor {
            NSLog("didAdd SCNNode")
            let plane = Plane(anchor: planeAnchar)
            self.planes[anchor.identifier] = plane
            node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchar = anchor as? ARPlaneAnchor {
            NSLog("didUpdate SCNNode")
            var plane : Plane?
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
