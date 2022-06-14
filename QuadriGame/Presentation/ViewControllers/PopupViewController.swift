//
//  PopupViewController.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 13/06/22.
//

import Foundation
import UIKit

class PopupViewController : UIViewController {
    
    @IBOutlet weak private var titleLabel : UILabel!
    @IBOutlet weak private var contentLabel : UILabel!
    @IBOutlet weak private var actionButton : UIButton!
    @IBOutlet weak private var mainView : UIView!

    var popupTitle : String?
    var content : String?
    var action : (()->())?
    var buttonTitle : String?
    var type : PopupType = .rules
    
    override func viewDidLoad() {
        mainView.layer.cornerRadius = 4

        var title : String?
        var content : String?
        var button : String?
        
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
    
        titleLabel.text = title ?? ""
        contentLabel.text = content ?? ""
        actionButton.setTitle(button  ?? "", for: .normal)
    }
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: action)
    }
    
}
