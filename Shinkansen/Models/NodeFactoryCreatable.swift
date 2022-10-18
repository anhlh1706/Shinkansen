//
//  NodeFactoryCreatable.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import Foundation
import SceneKit

public protocol NodeFactoryCreatable {
    init(node: SCNNode)
}

final class NodeFactory {
    
    static public var shared: NodeFactory?
    
    public var url: URL!
    
    public var isLoaded = false {
        didSet {
            // When all models are loaded, This method will execute all completion block.
            onFactoryLoadedCompletionBuffer.forEach { (callback) in
                callback()
            }
        }
    }
    
    private var modelData: [ModelData]?
    
    public var modelPrototypes: [String: SCNNode?] = [:]
    
    private var onFactoryLoadedCompletionBuffer: [() -> Void] = []
    
    /// Ge callback when all models are loaded
    /// - Parameter callback: Command to execute after models are loaded
    public func onComplete(callback: @escaping () -> Void) {
        onFactoryLoadedCompletionBuffer.append(callback)
    }
    
    public init(url: URL) {
        self.url = url
        Task.init {
            let data = await fetchModelData(url)
            if case .success(let success) = data {
                let node = await loadNode(from: success)
                finalizeData(node)
                
            }
        }
    }
    
    public init(modelData: [ModelData]) async {
        await finalizeData(loadNode(from: modelData))
    }
    
    /// if proviode URL let fetch model data from URL first
    /// - Parameter url: URL that contain json of `[ModelData]`
    private func fetchModelData(_ url: URL) async -> Result<[ModelData], Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode([ModelData].self, from: data)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
    
    /// Chained method to work after `[ModelData]` are generated
    /// - Parameter future: `[ModelData]` future object
    private func loadNode(from modelData: [ModelData]) async -> Result<[String: SCNNode?], Error> {
        self.modelData = modelData
        return await loadModels(
            from: Dictionary(
                uniqueKeysWithValues: modelData.compactMap {
                    switch $0.resource {
                    case .fileName(let filename):
                        return ($0.name, URL.resource(name: filename)) as? (String, URL)
                    case .url(let url):
                        return ($0.name, url)
                    default:
                        return nil
                    }
                }
            )
        )
    }
    
    /// Load all models by sequency
    /// - Parameter data: String = refernced key of model, URL = url of `*.scn` file
    public func loadModels(from data: [String: URL]) async -> Result<[String: SCNNode?], Error> {
        let d = await data.asyncMap({ await loadModel(name: $0, from: $1) })
        
        if let firstErrorCase = d.first(where: { (try? $0.get()) == nil }), case .failure(let failure) = firstErrorCase {
            return .failure(failure)
        }
        return .success(Dictionary(uniqueKeysWithValues: d.compactMap({ try? $0.get() })))
    }
    
    
    /// Load model (*.scn file) from url
    /// - Parameter name: Refernced key of mode
    /// - Parameter url: URL of `*.scn` file
    public func loadModel(name: String, from url: URL) async -> Result<(String, SCNNode?), Error> {
        /// returns pair of String, SCNNode
        if let node = await SCNReferenceNode(url: url) {
            await node.load()
            if let modelData = self.modelData?.first(where: {$0.name == name}),
               modelData.isInteractible {
                self.applyInteractiveCategoryBitmask(to: node)
            }
            return await .success((name, node.childNodes.first))
        } else {
            return .failure(NSError(domain: "NodeFactory",
                                    code: -9001,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: "URL of model seems wrong"]))
        }
    }
    
    private func finalizeData(_ result: Result<[String: SCNNode?], Error>) {
        switch result {
        case .success(let modelPrototypes):
            self.modelPrototypes = modelPrototypes
            self.isLoaded = true
        case .failure(let error):
            print(error)
        }
    }
    
    // MARK:- Create new node from prototype

    
    /// After models are loaded this function allow to create model from refferenced name
    /// by provoide generic object that conform to `StaticNode` protocol
    /// - Parameter name: Refferenced name of prototype node
    public func create(name: String) -> SCNNode? {
        guard let prototypeNode = modelPrototypes[name] as? SCNNode else {
            return nil
        }
        
        let clone = prototypeNode.clone()
        
        /// Deep clone new geometry from prototype recursively
        func cloneGeometry(from: SCNNode, to: SCNNode) {
            to.geometry = from.geometry?.copy() as? SCNGeometry
            zip(from.childNodes, to.childNodes).forEach {
                cloneGeometry(from: $0, to: $1)
            }
        }
        
        cloneGeometry(from: prototypeNode, to: clone)
        return clone
    }
    
    /// if class is conform to NodeFacotryCreatable will automatic returns as generic class
    public func create<T>(name: String) -> T? where T:  NodeFactoryCreatable {
        guard let node = create(name: name) else {
            return nil
        }
        return T(node: node)
    }
    
    /// Apply interactive cateogry bitmask
    private func applyInteractiveCategoryBitmask(to node: SCNNode) {
        node.categoryBitMask = InteractiveNode.defaultBitMask
        for node in node.childNodes {
            applyInteractiveCategoryBitmask(to: node)
        }
    }
    
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
