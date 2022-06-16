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
    
    static var winPawnViews : [Int] {
        return Array((0...Constant.cellForRow - 1))
    }
    
    static var winOppositePawnViews : [Int] {
        return Array((80...80+Constant.cellForRow - 1))
    }
    
    var isWinPawn : Bool {
        return Pawn.winPawnViews.contains(self.id)
    }
    
    var isWinOppositePawn : Bool {
        return Pawn.winOppositePawnViews.contains(self.id)
    }
    
    func possibleMoves() -> [Int] {
        var moves = [Int]()
        
        let row = Int(id/10) //0,10,20,30
        let column = id%10 //0,1,2,3,4
        
        //up
        if  row > 0 {
            moves.append(id - 10)
        }
        
        //right
        if column < Constant.cellForRow - 1 {
            moves.append(id + 1)
        }
        
        //down
        if  row < 80 {
            moves.append(id + 10)
        }
        
        //left
        if  column > 0 {
            moves.append(id - 1)
        }
        
        return moves
    }
    
    func possibleOpponentMoves() -> [Int] {
        var moves = [Int]()
        
        let row = Int(id/10) //0,10,20,30
        let column = id%10 //0,1,2,3,4
        
        //toward opposite side
        if  row < 80 {
            moves.append(id + 10)
        }
        
        //its rigth
        if  column > 0 {
            moves.append(id - 1)
        }
        
        //toward its side
        if  row > 0 {
            moves.append(id - 10)
        }
        
        //its left
        if column < Constant.cellForRow - 1 {
            moves.append(id + 1)
        }
        

        

        
        return moves
    }
    
    
        
    static func ==(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func !=(lhs: inout Pawn, rhs: Pawn) -> Bool {
        return lhs.id != rhs.id
    }
}

