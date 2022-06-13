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
    @IBOutlet weak private var stackContainer : UIStackView!

    var popupTitle : String? {
        didSet{
            titleLabel.text = popupTitle ?? ""
        }
    }
    
    var content : String? {
        didSet{
            contentLabel.text = content ?? ""
        }
    }
    
    @objc var action : (()->())? {
        didSet {
            actionButton.addTarget(self, action: #selector(getter: action), for: .touchUpInside)
        }
    }
    
    var buttonTitle : String? {
        didSet {
            actionButton.setTitle(buttonTitle ?? "", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        stackContainer.layer.cornerRadius = 4
    }
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
