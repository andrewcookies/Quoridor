//
//  Player.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 15/06/22.
//

import UIKit
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    
    var color: UIColor
    var name: String
    var playerId: Int
    var pawn : Pawn
    static var allPlayers = [Player(color : .red, name : "You", id : Constant.firstPlayer), Player(color: .black, name: "CPU", id: Constant.secondPlayer)]
    
    
    var opponent: Player {
        if playerId == Constant.firstPlayer {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }

    init(color : UIColor, name : String, id : Int) {
        self.color = color
        self.name = name
        self.playerId = id
        if id == Constant.firstPlayer {
            pawn = Pawn.starterPawn
        } else {
            pawn = Pawn.starterOpponentPawn
        }
        
        super.init()
    }

    func isWin() -> Bool {
        if playerId == Constant.firstPlayer {
            return pawn.isWinPawn
        } else {
            return pawn.isWinOppositePawn
        }
    }
}