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
        let navigation = BoardViewNavigation(showPopup: { [weak self] type,callback in
            self?.showPopup(type: type, callback: callback )
        })
        let viewModel = BoardViewModel(navigation: navigation)
        (viewController as? BoardViewController)?.viewModel = viewModel
        startViewController = viewController
    }
    
    
    
    
    //MARK: private method
    private func showPopup(type : PopupType,callback: @escaping ()->() ){
        let popup = PopupViewController(nibName: "PopupView", bundle: nil)
        var title : String?
        var content : String?
        var button: String?
        
        
        switch type {
        case .win:
            title = Localized.win_title
            content = Localized.win_content
            button = Localized.win_button
        case .rules:
            title = Localized.rules_title
            content = Localized.rules_content
            button = Localized.rules_button
        case .restart:
            title = Localized.restart_title
            content = Localized.restart_content
            button = Localized.restart_button
        }
        popup.popupTitle = title
        popup.content = content
        popup.action = callback
        popup.buttonTitle = button
        
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .fullScreen
        
        startViewController?.present(popup, animated: true)
    }
    
    
}
