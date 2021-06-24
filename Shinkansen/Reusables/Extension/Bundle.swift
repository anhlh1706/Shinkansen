//
//  Bundle.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 05/03/2021.
//

import Foundation

extension Bundle {
    
    func decode<T: Decodable>(fileName: String, type: T.Type) throws -> T? {
        guard let path = path(forResource: fileName, ofType: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch (let error) {
            throw error
        }
    }
}
