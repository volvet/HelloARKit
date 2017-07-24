//
//  Cube.swift
//  HelloARKit
//
//  Created by Volvet Zhang on 2017/7/24.
//  Copyright © 2017年 Volvet Zhang. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Cube : SCNNode {
    
    init(position : SCNVector3, withMaterial material : SCNMaterial) {
        super.init()
        
        let dimension : CGFloat = 0.2
        let cube = SCNBox(width: dimension, height: dimension, length: dimension, chamferRadius: 0)
        cube.materials = [material]
        
        let node = SCNNode(geometry: cube)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.categoryBitMask = CollisionCategoryCube
        node.position = position
        
        self.addChildNode(node)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        self.removeFromParentNode()
    }
    
    func changeMaterial() {
        //TODO
    }
    
    static func currentMaterial() -> SCNMaterial? {
        //TODO
        return nil
    }
}
