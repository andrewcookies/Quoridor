//
//  BoardViewModel.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine



struct BoardViewNavigation { }

enum GameState {
    case freeMove
    case movePawn
    case pickWall
    case reset
}

//TODO: 1 - remove all walls, 2 - reset board
    

protocol BoardViewModelProtocol {
    var pawn : Published<Pawn?>.Publisher { get }
    var wall : Published<Wall?>.Publisher { get }
    var gameState : Published<GameState?>.Publisher { get }
    var wallsOnBoard : Int { get }
    
    func makeMove(tag : Int)
    func setGameState(state : GameState)
}


class BoardViewModel {
    
    private let navigation : BoardViewNavigation?
    private var walls_OnBoard : [Wall]?
    @Published private var pawnPosition : Pawn?
    @Published private var newWall : Wall?
    @Published private var gs : GameState?

    
    init(navigation : BoardViewNavigation) {
        self.navigation = navigation
        pawnPosition = Pawn.starterPawn
        walls_OnBoard = []
        gs = .freeMove
    }
    
    func putWall(tagView: Int) {
        guard let walls = walls_OnBoard else { return }
        let candidateWall = Wall(firstWall: tagView, secondWall: tagView.isVerticalWall ? (tagView-10) : (tagView+1))
        gs = .freeMove
        if walls.contains(where: { $0.conflicts(wall: candidateWall) }).not {
            newWall = candidateWall
            walls_OnBoard?.append(candidateWall)
        } else {
            newWall = nil
        }
    }
    
    func movePawn(tagView: Int) {
        guard let currentId = pawnPosition?.id, let walls = walls_OnBoard else { return }
        if currentId == tagView {
            // do nothing in this moment, the pawn does not move
            
        } else {
            //check if I can move or there's a wall
            let translation = tagView - currentId
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
                    pawnPosition = Pawn(id: tagView)
                    gs = .freeMove
                }
            }
        }
    }
}

extension BoardViewModel : BoardViewModelProtocol {

    var gameState: Published<GameState?>.Publisher {
        $gs
    }
    
    var wallsOnBoard: Int {
        return walls_OnBoard?.count ?? 0
    }
    
    var pawn: Published<Pawn?>.Publisher {
        $pawnPosition
    }
    
    var wall: Published<Wall?>.Publisher {
        $newWall
    }
    
    
    func makeMove(tag : Int) {
        let type = tag.boardElement()
        switch type {
        case .rightBar, .bottomBar:
            if gs == .pickWall {
                putWall(tagView: tag)
            }
        case .cell:
            if gs == .movePawn {
                movePawn(tagView: tag)
            }
        }
        
    }

    func setGameState(state: GameState) {
        if state == gs {
            gs = .freeMove
        } else {
            gs = state
        }
    }
    
    
    
}
