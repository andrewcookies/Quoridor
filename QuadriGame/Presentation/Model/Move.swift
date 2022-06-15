//
//  Move.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 15/06/22.
//

import GameplayKit
import UIKit

enum MoveType {
    case movePawn
    case addWall
}

class Move: NSObject, GKGameModelUpdate {
    var value: Int
    
    var pawn : Pawn?
    var wall : Wall?
    var type : MoveType?
    
    
    init(value : Int, type: MoveType, pawn : Pawn? = nil, wall : Wall? = nil) {
        self.value = value
        self.type = type
        self.pawn = pawn
        self.wall = wall
    }
}
