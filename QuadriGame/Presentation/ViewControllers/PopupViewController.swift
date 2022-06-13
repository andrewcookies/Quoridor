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
    
    override func viewDidLoad() {
        mainView.layer.cornerRadius = 4
        titleLabel.text = popupTitle ?? ""
        contentLabel.text = content ?? ""
        actionButton.setTitle(buttonTitle ?? "", for: .normal)
    }
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        if let action = action {
            action()
        } else {
            self.dismiss(animated: true)
        }
    }
    
}
