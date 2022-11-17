//
//  TitlNodeMotionEffect.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import SceneKit

class TiltNodeMotionEffect: UIMotionEffect {
    
    private var basedEulerAngles = SCNVector3Zero
    private var basedPosition = SCNVector3Zero
    
    /// `SCNNode` that will be tilted or reposition based on visual effect
    weak var node: SCNNode?
    
    /// Intensity of vertical tilt
    var verticalTiltedIntensity: CGFloat = 1 / 4
    
    /// Intensity of horizontal tilt
    var horizontalTiltedIntensity: CGFloat = 1 / 24
    
    /// Intensity of vertical shift
    var verticalShiftedIntensity: CGFloat = 0
    
    /// Intensity of horizontal shift
    var horizontalShiftedIntensity: CGFloat = 1 / 2
    
    /// Add motion effect to `SCNNode`
    ///
    /// - Parameter node: `SCNNode` that will be tilted or reposition based on visual effect
    init(node: SCNNode) {
        super.init()
        self.node = node // Set value at init
        basedPosition = node.position
        basedEulerAngles = node.eulerAngles
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {

        // Shifting position
        node?.position = SCNVector3Make(
            basedPosition.x + Float(viewerOffset.horizontal * horizontalShiftedIntensity),
            basedPosition.y - Float(viewerOffset.vertical * verticalShiftedIntensity),
            basedPosition.z )
 
        // Tilting Angle
        node?.eulerAngles = SCNVector3Make(basedEulerAngles.x + Float(viewerOffset.vertical * verticalTiltedIntensity), basedEulerAngles.y + Float(viewerOffset.horizontal * horizontalTiltedIntensity), basedEulerAngles.z)
        return nil
    }
}

class HitTestFloorNode: SCNNode {
    
    override init() {
        super.init()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        let hitTestFloor = SCNFloor()
        hitTestFloor.reflectivity = 0.001
        hitTestFloor.firstMaterial?.transparency = 0
        geometry = hitTestFloor
        position.y = 1.3
        categoryBitMask = 1 << 1
    }
}

class PlaceholderSeatNode: SeatNode {
    
     init() {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(node: SCNNode) {
        fatalError("init(node:modelData:) has not been implemented")
    }
}
