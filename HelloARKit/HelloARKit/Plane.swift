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
        
        material.diffuse.contents = #imageLiteral(resourceName: "tron_grid.png")
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


class PlaneEx : SCNNode {
    init(anchor : ARPlaneAnchor, isHidden : Bool) {
        self.anchor = anchor
        
        let width = anchor.extent.x
        let height = 0.1
        let length = anchor.extent.z
        self.planeGeometry = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0)
        
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "tron_grid.png")
        
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        
        if isHidden {
            self.planeGeometry.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial]
        } else {
            self.planeGeometry.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, material, transparentMaterial]
        }
        
        let planeNode = SCNNode(geometry  : self.planeGeometry)
        planeNode.position = SCNVector3Make(0, Float(-height/2), 0)
        
        //A physics body that is unaffected by forces or collisions but that can cause collisions affecting other bodies when moved.
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        self.addChildNode(planeNode)
        self.setTextureScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchar : ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchar.extent.x)
        self.planeGeometry.length = CGFloat(anchar.extent.z)
        
        self.position = SCNVector3Make(anchar.center.x, 0, anchar.center.z)
        let node : SCNNode? = self.childNodes.first
        node?.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        self.setTextureScale()
    }
    
    func setTextureScale() {
        let width = self.planeGeometry.width
        let height = self.planeGeometry.height
        
        let material = self.planeGeometry.materials[4]
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material.diffuse.wrapS = .`repeat`
        material.diffuse.wrapT = .`repeat`
    }
    
    func hide() {
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        self.planeGeometry.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial]
    }
    
    var anchor : ARPlaneAnchor
    var planeGeometry : SCNBox
}


