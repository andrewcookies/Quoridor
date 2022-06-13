//
//  Cell.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine

extension Notification.Name {
    static let newPawnPosition = Notification.Name("new_pawn_position")
}

struct Pawn {
    let id : Int
    static var starterPawn : Pawn {
        return Pawn(id: 84)
    }
    
    static func ==(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func !=(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id != rhs.id
    }
}

