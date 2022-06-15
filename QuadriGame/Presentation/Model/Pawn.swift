//
//  Cell.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine


struct Pawn {
    let id : Int
    static var starterPawn : Pawn {
        return Pawn(id: Constant.startCellTag)
    }
    
    static var starterOpponentPawn : Pawn {
        return Pawn(id: Constant.startOpponentCellTag)
    }
    
    var isWinPawn : Bool {
        return (0...Constant.cellForRow - 1).contains(self.id)
    }
    
    var isWinOppositePawn : Bool {
        return (80...80+Constant.cellForRow - 1).contains(self.id)

    }
        
    static func ==(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func !=(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id != rhs.id
    }
}

