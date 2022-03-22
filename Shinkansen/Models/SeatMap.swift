//
//  SeatMap.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import SceneKit

struct SeatMap: Decodable {
    let id: Int
    let name: String
    let seatClassEntities: [SeatClassEntity]
    let transformedModelEntities: [TransformedModelEntity]
    let transformedTextModelEntities: [TextNode]
    
    /// Async method to get SeatMap data from DataAsset
    /// returns result of `SeatMap`
    /// - Parameter completion: completion block
    static func fetchData(completion: @escaping (Result<SeatMap, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let data = NSDataAsset(name: "SeatMap")?.data else {
                return completion(.failure(NSError(domain: "SeatMap", code: -900, userInfo: [NSLocalizedFailureReasonErrorKey: "Please check SeatMap.json in assets directory."])))
            }
            do {
                // try to decode SeatMap object from json
                let decoder = JSONDecoder()
                let seatMap = try decoder.decode(SeatMap.self, from: data)
                completion(.success(seatMap))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}

class SeatClassEntity: Codable {
    let id: Int
    let seatClass: SeatClassType
    let name: String
    let carNumber: String
    let reservableEntities: [ReservableEntity]
    let viewableRange: ClosedRange<SCNVector3>
    let transformedModelEntities: [TransformedModelEntity]
}

struct ReservableEntity: Codable {
    let id: Int
    let name: String
    let carNumber: String
    let isAvailable: Bool
    let transformedModelEntity: TransformedModelEntity
}

struct TransformedModelEntity: Codable {
    let modelEntity: String
    let position: SCNVector3
    let rotation: SCNVector3
}


class TextNode: SCNNode, Decodable {
    
    private var textContentNode: SCNNode
    
    enum TextAlignment: String, Codable {
        case left
        case center
        case right
        
        func offsetBy(_ contentNode: SCNNode) -> Float {
            switch self {
            case .left:
                return 0
            case .center:
                return -(contentNode.boundingBox.max.x - contentNode.boundingBox.min.x) / 2
            case .right:
                return -contentNode.boundingBox.max.x
            }
        }
    }
    
    var textAlignment: TextAlignment = .center
    
    var text: String?
    
    init(text: String? = nil,
         font: UIFont =
        .systemFont(ofSize: 0.25,
                    weight: .medium),
         textAlignment: TextAlignment = .center,
         color: UIColor,
         estimatedWidth: CGFloat = 1) {
        
        textContentNode = SCNNode()
        super.init()
        setupNode(text: text,
                  font: font,
                  textAlignment: textAlignment,
                  color: color,
                  estimatedWidth: estimatedWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(from decoder: Decoder) throws {
        textContentNode = SCNNode()
        super.init()
        let container = try decoder.container(keyedBy: Key.self)
        let text = try container.decode(String.self, forKey: .text)
        textAlignment = try container.decode(TextAlignment.self, forKey: .textAlignment)
        let font = try container.decode(FontModel.self, forKey: .font).font()
        
        setupNode(text: text,
                  font: font,
                  textAlignment: textAlignment,
                  color: .subtext,
                  estimatedWidth: 1)
        position = try container.decode(SCNVector3.self, forKey: .position)
        eulerAngles = try container.decode(SCNVector3.self, forKey: .rotation)
    }
    
    func setColor(to color: UIColor) {
        textContentNode.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    private func setupNode(text: String?,
                           font: UIFont,
                           textAlignment: TextAlignment,
                           color: UIColor,
                           estimatedWidth: CGFloat) {
        
        let text = SCNText(string: text, extrusionDepth: 0.005)
        text.firstMaterial?.diffuse.contents = color
        text.font = font
        text.flatness = 0.6 / ( 36 / text.font.pointSize )
        text.containerFrame = CGRect(x: 0, y: 0, width: estimatedWidth, height: text.font.pointSize)
        textContentNode.geometry = text
        textContentNode.eulerAngles.x = -.pi / 2
        textContentNode.position.z = Float(text.font.pointSize + text.font.capHeight / 2)
        
        // make the text node aligned
        textContentNode.position.x = textAlignment.offsetBy(textContentNode)
        
        addChildNode(textContentNode)
        
    }
    
    enum Key: String, CodingKey {
        case text, font, textAlignment, position, rotation
    }
}

private struct FontModel: Decodable {
    let size: CGFloat
    let weight: UIFont.Weight
    
    enum Key: String, CodingKey {
        case size, weight
    }
    
    func font() -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .black)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        size = try container.decode(CGFloat.self, forKey: .size)
        switch try container.decode(String.self, forKey: .weight) {
        case "black":
            weight = .black
        case "bold":
            weight = .bold
        case "medium":
            weight = .medium
        case "regular":
            weight = .regular
        case "semibold":
            weight = .semibold
        case "thin":
            weight = .thin
        case "light":
            weight = .light
        case "ultralight":
            weight = .ultraLight
        default:
            weight = .regular
        }
    }
}
