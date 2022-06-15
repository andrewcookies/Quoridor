//
//  Cell.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 15/06/22.
//

import Foundation


struct Cell {
    var tag : Int
    var pawnInCell : Pawn?
    
    func isEmpty() -> Bool {
        return pawnInCell == nil
    }
    
}
