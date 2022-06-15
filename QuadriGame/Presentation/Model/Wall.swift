//
//  Wall.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine

enum BoardElement {
    case rightBar
    case bottomBar
    case cell
}

struct Wall {
    let firstWall : Int
    let secondWall : Int
    
    func conflicts(wall : Wall) -> Bool {
        return (firstWall == wall.firstWall || secondWall == wall.firstWall || firstWall == wall.secondWall || firstWall == wall.secondWall + 100 )
    }
}
