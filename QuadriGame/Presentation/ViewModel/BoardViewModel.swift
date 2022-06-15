//
//  BoardViewModel.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 10/06/22.
//

import Foundation
import Combine
import GameplayKit


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
    func continueGame()
}


class BoardViewModel: NSObject {
    
    private let navigation : BoardViewNavigation?
    
    private var walls_OnBoard : [Wall]?
    private var currentPlayer : Player?
    
    @Published private var pawnPosition : Pawn?
    @Published private var newWall : Wall?
    @Published private var gs : GameState?

    
    init(navigation : BoardViewNavigation) {
        self.navigation = navigation
        currentPlayer = Player.allPlayers[0]
        pawnPosition = Pawn.starterPawn
        walls_OnBoard = []
        gs = .freeMove
    }
    
    func isWin( for player : GKGameModelPlayer) -> Bool {
        return (player as! Player).isWin()
    }
    
    func canPutWall(wall : Wall) -> Bool {
        guard let walls = walls_OnBoard else { return false }
        if walls.contains(where: { $0.conflicts(wall: wall) }).not && wallsOnBoard < Constant.totaleWallsInGame {
            return true
        } else {
            return false
        }
    }
    
    func putWall(tagView: Int) {
        gs = .freeMove
        let candidateWall = Wall(firstWall: tagView, secondWall: tagView.isVerticalWall ? (tagView-10) : (tagView+1))
        if canPutWall(wall: candidateWall) {
            newWall = candidateWall
            walls_OnBoard?.append(candidateWall)
        } else {
            newWall = nil
        }
    }
    
    func canMovePawn( tagView: Int ) -> Bool {
        guard let currentId = pawnPosition?.id, let walls = walls_OnBoard else { return false }
        if currentId == tagView {
            // do nothing in this moment, the pawn does not move
            return false
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
                    return true
                }
            }
            
            return false
        }
    }
    
    func movePawn(tagView: Int) {
        if canMovePawn(tagView: tagView){
            pawnPosition = Pawn(id: tagView)
            gs = .freeMove
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
                continueGame()
            }
        case .cell:
            if gs == .movePawn {
                movePawn(tagView: tag)
                continueGame()
            }
        }
        
    }

    func setGameState(state: GameState) {
        if state == gs {
            gs = .freeMove
        } else {
            gs = state
        }
        
        if state == .reset {
            walls_OnBoard?.removeAll()
        }
        
    }
    
    func continueGame() {
        //manage observable logic UI
        if isWin(for: currentPlayer ?? Player.allPlayers[0]){
            //update something
        } else {
            currentPlayer = currentPlayer?.opponent
        }
                 
        //update UI
    }
    
    
}

//MARK: IA

extension BoardViewModel : GKGameModel {
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? BoardViewModel {
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        if let playerObject = player as? Player {
            if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
                return nil
            }
            
            var moves = [Move]()
            
            for view in playerObject.pawn.possibleMoves() {
                //core logic
                if canMovePawn(tagView: view) {
                    moves.append(Move(type: .movePawn, pawn: Pawn(id: view)))
                }
            }
            
            return moves
        }
        
        return nil
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            //add(chip: currentPlayer.chip, in: move.column)
            if move.type == .movePawn {
                currentPlayer?.pawn = move.pawn ?? Pawn.starterPawn
            } else {
                //add wall
                //..to be added
            }
            currentPlayer = currentPlayer?.opponent
        }
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWin(for: playerObject) {
                return 1000
            } else if isWin(for: playerObject.opponent) {
                return -1000
            }
        }

        return 0
    }
    
  
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = BoardViewModel(navigation: navigation ?? BoardViewNavigation())
        copy.setGameModel(self)
        return copy
    }
    
    
}
