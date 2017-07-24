//
//  PBRMaterial.swift
//  HelloARKit
//
//  Created by Volvet Zhang on 2017/7/24.
//  Copyright © 2017年 Volvet Zhang. All rights reserved.
//

import Foundation
import SceneKit

class PBRMaterial {
    static func materialByName(name : String) -> SCNMaterial? {
        
        var material = PBRMaterial.materials[name]
        
        if (material != nil) {
            return material
        }
        
        material = SCNMaterial()
        material?.lightingModel = .physicallyBased
        material?.diffuse.contents = UIImage(named: "./Assets.scassets/Materials/" + name + "/" + name + "-albedo.png")
        material?.roughness.contents = UIImage(named: "./Assets.scassets/Materials/" + name + "/" + name + "-roughnes.png")
        material?.roughness.contents = UIImage(named: "./Assets.scassets/Materials/" + name + "/" + name + "-metal.png")
        material?.normal.contents = UIImage(named: "./Assets.scassets/Materials/" + name + "/" + name + "-normal.png")
        
        material?.diffuse.wrapS = .`repeat`
        material?.diffuse.wrapT = .`repeat`
        material?.roughness.wrapS = .`repeat`
        material?.roughness.wrapT = .`repeat`
        material?.roughness.wrapS = .`repeat`
        material?.roughness.wrapT = .`repeat`
        material?.normal.wrapS = .`repeat`
        material?.normal.wrapT = .`repeat`
        
        materials[name] = material
        
        return material
    }
    
    static var materials = Dictionary<String, SCNMaterial>()
}
