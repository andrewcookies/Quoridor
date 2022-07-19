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

struct Wall : Equatable {
    let firstWall : Int
    let secondWall : Int
    
    var isVertical : Bool {
        return firstWall.isVerticalWall && secondWall.isVerticalWall
    }
    
    var isHorizontal : Bool {
        return firstWall.isHorizontalWall && secondWall.isHorizontalWall
    }

    
    func conflicts(wall : Wall) -> Bool {
        return (firstWall == wall.firstWall || secondWall == wall.firstWall || firstWall == wall.secondWall || firstWall == wall.secondWall + 100 )
    }
    
    
    //for horizontal wall
    private func hNorthEastWall() -> Wall? {
        let firstWall = secondWall + 100
        let secondWall = firstWall - 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func hSouthEastWall() -> Wall? {
        let secondWall = secondWall + 10 - 100
        let firstWall = secondWall + 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func hSouthWestWall() -> Wall? {
        let secondWall = firstWall - 1 + 10 - 100
        let firstWall = secondWall + 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    
    private func hNorthWestWall() -> Wall? {
        let firstWall = firstWall - 1 - 100
        let secondWall = firstWall - 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func nextHorizontal() -> Wall? {
        let firstWall = secondWall + 1
        let secondWall = firstWall + 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func previousHorizontal() -> Wall? {
        let secondWall = firstWall - 1
        let firstWall = secondWall - 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    //for vertical
    
    private func vNorthEastWall() -> Wall? {
        let firstWall = secondWall - 10 + 100 + 1
        let secondWall = firstWall + 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func vSouthEastWall() -> Wall? {
        let firstWall = firstWall + 10 + 100
        let secondWall = firstWall + 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func vSouthWestWall() -> Wall? {
        let secondWall = firstWall + 100
        let firstWall = secondWall - 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func vNorthWestWall() -> Wall? {
        let secondWall = secondWall - 10 + 100
        let firstWall = secondWall - 1
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func nextVertical() -> Wall? {
        let firstWall = secondWall - 10
        let secondWall = firstWall - 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    private func previousVertical() -> Wall? {
        let secondWall = firstWall + 10
        let firstWall = secondWall + 10
        
        if firstWall.isOutOfBound.not && secondWall.isOutOfBound.not {
            return Wall(firstWall: firstWall, secondWall: secondWall)
        }
        return nil
    }
    
    func northEastWall() -> Wall? {
        return isVertical ? vNorthEastWall() : hNorthEastWall()
    }
    
    func northWestWall() -> Wall? {
        return isVertical ? vNorthWestWall() : hNorthWestWall()
    }
    
    func southWestWall() -> Wall? {
        return isVertical ? vSouthWestWall() : hSouthWestWall()
    }
    
    func southEastWall() -> Wall? {
        return isVertical ? vSouthEastWall() : hSouthEastWall()
    }

    func nextWall() -> Wall? {
        return isVertical ? nextVertical() : nextHorizontal()
    }
    
    func previousWall() -> Wall? {
        return isVertical ? previousVertical() : previousHorizontal()
    }
    
    static func == (lhs: Wall, rhs: Wall) -> Bool {
        return lhs.firstWall == rhs.firstWall && lhs.secondWall == rhs.secondWall
    }
    
}
