//
//  Collection+Extension.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 04/10/2024.
//

import UIKit

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
