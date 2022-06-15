//
//  Board.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 15/06/22.
//

import UIKit



class Board: NSObject {

    static var width = Constant.cellForRow
    static var height = Constant.cellForRow
    
    var cells = [Cell]()
    var currentPawn = Pawn.starterPawn
    var walls = [Wall]()

    override init() {
        var (x,y) = (0,0)
        while (x < Board.width && y < Board.height) {
            let id = 10*y + x
            cells.append(Cell(tag: id, pawnInCell: id == Constant.startCellTag ? currentPawn : nil ))
            x += 1
            if x == Board.width {
                x = 0
                y += 1
            }
        }
        walls.removeAll()
    }
    
    
    func pawn( tag : Int )->Pawn? {
       //return cells.filter({ $0.tag == tag }).first?.pawnInCell
        return currentPawn
    }
    
    func set( pawn : Pawn ){
        //let cell = cells.filter({ $0.tag == currentPawn.id }).first?.pawnInCell
        currentPawn = pawn
    }
    
    func set(wall : Wall){
        walls.append(wall)
    }
    
    func wall( tag : Int ) -> Wall? {
        return walls.filter({ $0.firstWall == tag || $0.secondWall == tag }).first
    }
    
    func canMovePawn( tag : Int ) -> Bool {
        let currentId = currentPawn.id
        if currentId == tag {
            return false
        } else {
            //check if I can move or there's a wall
            let translation = tag - currentId
            var wall : Int?
            
            if translation == 1 {
                //right move, check vertical wall
                wall = (currentId + 1) + 100
                
            }
            else if translation == -1 {
                //left move, check vertical wall
                wall = (currentId-1) + 100
            }
            else if translation == -10 {
                //top move, check horizontal wall
                wall = (currentId-10) + 200
                
            }
            else if translation == 10 {
                //bottom move, check horizontal wall
                wall = (currentId) + 200
                
            }
            
            
            if let w = wall {
                if walls.contains(where: { $0.firstWall == w || $0.secondWall == w }).not {
                    return true
                }
            }
            
            return false
        }
    }
    
    func movePawn( tag : Int ) {
        if canMovePawn(tag: tag){
            set(pawn: Pawn(id: tag))
        }
    }
    
}
