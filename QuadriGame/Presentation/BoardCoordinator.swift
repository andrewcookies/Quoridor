//
//  BoardCoordinator.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 13/06/22.
//

import Foundation
import UIKit


class BoardCoordinator {
    
    var startViewController : UIViewController?
    
    init(viewController : UIViewController?) {
        let viewModel = BoardViewModel(navigation: BoardViewNavigation())
        (viewController as? BoardViewController)?.viewModel = viewModel
        startViewController = viewController
    }
    
    
    
    
    //MARK: private method

    
    
}
