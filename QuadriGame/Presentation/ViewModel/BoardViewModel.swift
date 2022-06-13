//
//  BoardViewModel.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine

enum PopupType {
    case win
    case rules
    case restart
}

struct BoardViewNavigation { }

enum GameState {
    case freeMove
    case movePawn
    case pickWall
}


protocol BoardViewModelProtocol {
    var pawn : Published<Pawn?>.Publisher { get }
    var wall : Published<Wall?>.Publisher { get }
    var gameState : Published<GameState?>.Publisher { get }
    var wallsOnBench : Int { get }
    
    func makeMove(tag : Int)
    func setGameState(state : GameState)
    func showPopup(type : PopupType)
}


class BoardViewModel {
    
    private let navigation : BoardViewNavigation?
    private var wallsOnBoard : [Wall]?
    @Published private var pawnPosition : Pawn?
    @Published private var newWall : Wall?
    @Published private var gs : GameState?

    
    init(navigation : BoardViewNavigation) {
        self.navigation = navigation
        pawnPosition = Pawn.starterPawn
        wallsOnBoard = []
        gs = .freeMove
    }
    
    func putWall(tagView: Int) {
        guard let walls = wallsOnBoard else { return }
        let candidateWall = Wall(firstWall: tagView, secondWall: tagView.isVerticalWall ? (tagView-10) : (tagView+1))
        if walls.contains(where: { $0.conflicts(wall: candidateWall) }).not {
            newWall = candidateWall
            gs = .freeMove
            wallsOnBoard?.append(candidateWall)
        }
    }
    
    func movePawn(tagView: Int) {
        guard let currentId = pawnPosition?.id, let walls = wallsOnBoard else { return }
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
    
    var wallsOnBench: Int {
        return 10 - (wallsOnBoard?.count ?? 0)
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
    
    func showPopup(type : PopupType) {
        switch type {
        case .win:
            break
        case .rules:
            break
        case .restart:
            break
        }

    }
    
    
}
