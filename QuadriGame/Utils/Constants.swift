//
//  Constants.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 12/06/22.
//

import Foundation

final class Constant {
    
    static let pawnTag = 1000
    static let totaleWallsInGame = 10
    static let cellForRow = 9
    static let startCellTag = 84
    static let startOpponentCellTag = 84
    static let firstPlayer = 0
    static let secondPlayer = 1

    
    static let percentageHeightCellOnBoard = 0.10
    static let percentageWidthCellOnBoard = 0.10
    static let percentageWidthVerticalBarOnCell = 0.20
    static let percentageHeightVerticalBarOnCell = 1.0
    static let percentageWidthHorizontalBarOnCell = 1.0
    static let percentageHeightHorizontalBarOnCell = 0.20
    static let percentageHeightPawnOnCell = 1 - percentageWidthVerticalBarOnCell
    static let percentageWidthPawnOnCell = 1 - percentageHeightHorizontalBarOnCell
    
}
