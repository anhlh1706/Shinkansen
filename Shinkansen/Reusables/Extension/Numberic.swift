//
//  Numberic.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 08/03/2021.
//

import Foundation

extension Numeric {
    var yen: String {
        return YenFormatter().string(for: self)!
    }
}
