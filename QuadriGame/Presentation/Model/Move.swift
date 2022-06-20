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
    var value: Int = 0
    
    var pawn : Pawn?
    var wall : Wall?
    var type : MoveType?
    
    
    init(type: MoveType, pawn : Pawn? = nil, wall : Wall? = nil) {
        self.type = type
        self.pawn = pawn
        self.wall = wall
    }
}
