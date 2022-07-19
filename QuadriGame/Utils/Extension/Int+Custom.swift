//
//  Int+Custom.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 11/06/22.
//

import Foundation


extension Int {
    
    var isVerticalWall : Bool {
        return boardElement() == .rightBar
    }
    
    
    var isHorizontalWall : Bool {
        return boardElement() == .bottomBar
    }
    
    var isOutOfBound : Bool {
        let ooo = [109,119,129,139,149,159,169,179,189,209,219,229,239,249,259,269,279,289]
        return ooo.contains(self)
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
