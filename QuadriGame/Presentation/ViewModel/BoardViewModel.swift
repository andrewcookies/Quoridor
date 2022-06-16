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
    case opponentMove
    case wonGame
    case lostGame
}
    

protocol BoardViewModelProtocol {
    var wall : Published<Wall?>.Publisher { get }
    var gameState : Published<GameState?>.Publisher { get }
    var player : Player { get }
    
    func makeMove(tag : Int)
    func setGameState(state : GameState)
    func startGame()
    func resetGame()
    func makeAIMove()
}


class BoardViewModel: NSObject {
    
    private let navigation : BoardViewNavigation?
    private var walls_OnBoard : [Wall] {
        return player.walls + player.opponent.walls
    }
    private var strategist: GKMinmaxStrategist!
    
    @Published private var newWall : Wall?
    @Published private var gs : GameState?
    
    var currentPlayer : Player?

    
    init(navigation : BoardViewNavigation) {
        self.navigation = navigation
    }

    func initStrategist(){
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 7
        strategist.randomSource = GKARC4RandomSource()
        strategist.gameModel = self
    }
    
    func isWin( for player : GKGameModelPlayer) -> Bool {
        return (player as! Player).isWin()
    }
    
    func canPutWall(wall : Wall) -> Bool {
        let walls = walls_OnBoard
        if walls.contains(where: { $0.conflicts(wall: wall) }).not && player.walls.count < Constant.totaleWallsInGame {
            return true
        } else {
            return false
        }
    }
    
    func putWall(tagView: Int) {
        gs = .freeMove
        let candidateWall = Wall(firstWall: tagView, secondWall: tagView.isVerticalWall ? (tagView-10) : (tagView+1))
        if canPutWall(wall: candidateWall) {
            player.walls.append(candidateWall)
            newWall = candidateWall
        } else {
            newWall = nil
        }
    }
    
    func canMovePawn( tagView: Int ) -> Bool {
        let walls = walls_OnBoard
        let currentId = player.pawn.id
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
            player.pawn = Pawn(id: tagView)
            gs = .freeMove
        }
    }
    
    private func continueGame() {
        //manage observable logic UI
        if isWin(for: currentPlayer ?? Player.allPlayers[0]){
            gs = (currentPlayer?.isMe ?? true) ? .wonGame : .lostGame
        } else {
            currentPlayer = currentPlayer?.opponent
            gs = (currentPlayer?.isMe ?? true) ? .freeMove : .opponentMove
        }
                 
    }
}

extension BoardViewModel : BoardViewModelProtocol {
    
    var player: Player {
        return currentPlayer ?? Player.allPlayers[0]
    }
    

    var gameState: Published<GameState?>.Publisher {
        $gs
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
    
    func startGame() {
        initStrategist()
        resetGame()
    }
    
    func resetGame(){
        currentPlayer = Player.allPlayers[0]
        gs = .reset
    }

    func setGameState(state: GameState) {
        if state == gs {
            gs = .freeMove
        } else {
            gs = state
        }
    }
    
    //MARK: AI
    func makeAIMove() {
        //loading?
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let tagView = self.getBestMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.moveAIPawn(tag: tagView)
            }
        }
    }

    func getBestMove() -> Int? {
        if let aiMove = strategist.bestMove(for: player ) as? Move {
            return aiMove.pawn?.id
         }
         return nil
    }
    
    func moveAIPawn( tag : Int) {
        movePawn(tagView: tag)
        continueGame()
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
                //core IA logic
                if canMovePawn(tagView: view) {
                    moves.append(Move(value: 0, type: .movePawn, pawn: Pawn(id: view)))
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
