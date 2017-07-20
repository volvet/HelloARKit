//
//  Plane.swift
//  HelloARKit
//
//  Created by Volvet Zhang on 2017/7/19.
//  Copyright © 2017 Volvet Zhang. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import UIKit

class Plane : SCNNode {
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        super.init()
        
        let material = SCNMaterial()
        let img = UIImage(named: "tron_grid.png")
        material.diffuse.contents = img
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // Why need rotate here?
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi)/2.0, 1.0, 0.0, 0.0)
        self.addChildNode(planeNode)
        setTextureScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(PlanAnchor anchor : ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        setTextureScale()
    }
    
    func setTextureScale() {
        let width = self.planeGeometry.width
        let height = self.planeGeometry.height
        
        let material = self.planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material?.diffuse.wrapS = .`repeat`
        material?.diffuse.wrapT = .`repeat`
    }
    
    var anchor : ARPlaneAnchor
    var planeGeometry : SCNPlane
}

