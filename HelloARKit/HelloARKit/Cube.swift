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
        
        let dimension : CGFloat = 0.1
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
        Cube.currentMaterialIndex = (Cube.currentMaterialIndex + 1)%4
        self.childNodes.first?.geometry?.materials = [Cube.currentMaterial()]
    }
    
    static func currentMaterial() -> SCNMaterial {
        //TODO
        var materialName : String? = nil
        
        switch (currentMaterialIndex) {
        case 0:
            materialName = "rustediron-streaks"
            break
        case 1:
            materialName = "carvedlimestoneground"
            break
        case 2:
            materialName = "granitesmooth"
            break
        case 3:
            materialName = "old-textured-fabric"
            break
        default:
            materialName = "rustediron-streaks"
        }
        return PBRMaterial.materialByName(name: materialName!)
    }
    
    static var currentMaterialIndex : Int = 0
}
