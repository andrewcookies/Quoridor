//
//  Int+Custom.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 11/06/22.
//

import Foundation


extension Int {
    
    var isVerticalWall : Bool {
        if (100...199).contains(self) {
            return true
        }
        return false
    }
    
    
    var isHorizontalWall : Bool {
        if (200...299).contains(self) {
            return true
        }
        return false
    }
    
    
    var isCell : Bool {
        if (0...99).contains(self)  {
            return true
        }
        return false
    }
    
    func boardElement() -> BoardElement {
        if (0...99).contains(self)  {
            return .cell
        }
        
        if (100...199).contains(self) {
            return .rightBar
        }
        
        if (200...299).contains(self) {
            return .bottomBar
        }
        
        return .cell
    }
}
