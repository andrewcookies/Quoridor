//
//  ViewController.swift
//  QuadriGame
//
//  Created by Andrea Colussi on 09/06/22.
//

import UIKit
import Combine



final class BoardViewController: UIViewController {

    let pawnTag = 1000
    
    var viewModel : BoardViewModelProtocol?
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movePawnButton: UIButton!
    @IBOutlet weak var pickUpWallButton: UIButton!
    @IBOutlet weak var infoMoveLabel: UILabel!
    @IBOutlet weak var restartUIImage: UIImageView!
    @IBOutlet weak var infoUIImage: UIImageView!
    
    
    private var subscribers: [AnyCancellable] = []
    private var currentPawn = Pawn.starterPawn {
        didSet{
            addPawn(pawn: currentPawn)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
        
    }

    private func setupObserver() {
        viewModel?.pawn.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] newPawn in
            guard let self = self, let newPawn = newPawn else { return }
            print("newPawn: \(newPawn.id)")
            self.currentPawn = newPawn
        }).store(in: &subscribers)
        
        viewModel?.wall.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] newWall in
            guard let self = self, let newWall = newWall else { return }
            print("newWall: \(newWall.firstWall) - \(newWall.secondWall)")
            
            self.addWall(newWall: newWall)

        }).store(in: &subscribers)
        
        viewModel?.gameState.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] gameState in
            guard let self = self, let gameState = gameState else { return }
            print("gameState: \(gameState)")
            self.updateUI(gameState)
        }).store(in: &subscribers)
    }
    
        
    //MARK: UI handling
    private func setupUI(){
        handlingActions()
        createBoard()
    }
    
    private func handlingActions(){
        infoUIImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapInfo(_:))))
        restartUIImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapRestart(_:))))
        
    }
    
    private func updateUI( _ state : GameState = .freeMove){
        switch state {
        case .freeMove:
            infoMoveLabel.text = Localized.info_move_generic
            
            movePawnButton.setTitle(Localized.move_pawn, for: .normal)
            movePawnButton.isUserInteractionEnabled = true
            movePawnButton.alpha = 1
            
            let title = String(format: Localized.pick_wall, "\(viewModel?.wallsOnBench ?? 0)")
            pickUpWallButton.setTitle(title, for: .normal)
            pickUpWallButton.isUserInteractionEnabled = true
            pickUpWallButton.alpha = 1
            
            boardView.isUserInteractionEnabled = false
            
        case .movePawn:
            infoMoveLabel.text = Localized.info_move_pawn

            movePawnButton.setTitle(Localized.cancel_move, for: .normal)
            movePawnButton.isUserInteractionEnabled = true
            movePawnButton.alpha = 1
            
            let title = String(format: Localized.pick_wall, "\(viewModel?.wallsOnBench ?? 0)")
            pickUpWallButton.setTitle(title, for: .normal)
            pickUpWallButton.isUserInteractionEnabled = false
            pickUpWallButton.alpha = 0.5
            
            boardView.isUserInteractionEnabled = true
            
        case .pickWall:
            infoMoveLabel.text = Localized.info_put_wall

            movePawnButton.setTitle(Localized.move_pawn, for: .normal)
            movePawnButton.isUserInteractionEnabled = false
            movePawnButton.alpha = 0.5

            pickUpWallButton.setTitle(Localized.cancel_move, for: .normal)
            pickUpWallButton.isUserInteractionEnabled = true
            pickUpWallButton.alpha = 1
            
            boardView.isUserInteractionEnabled = true

        }
        
    }
    
    private func addWall( newWall : Wall){
        
        let firstWallView = self.boardView.viewWithTag(newWall.firstWall)
        let secondWallView = self.boardView.viewWithTag(newWall.secondWall)
        
        let joinWallH = CGFloat((firstWallView?.frame.height) ?? 0.0) + CGFloat((secondWallView?.frame.height) ?? 0.0)
        let joinWallW = CGFloat((secondWallView?.frame.width) ?? 0.0) + CGFloat((secondWallView?.frame.width) ?? 0.0)
        
        let origin : CGPoint?
        if newWall.firstWall.isVerticalWall {
            let cellView = self.boardView.viewWithTag(newWall.secondWall - 100)
            origin = cellView?.convert(secondWallView?.frame ?? CGRect.zero, to: self.boardView).origin
        } else {
            let cellView = self.boardView.viewWithTag(newWall.firstWall - 200)
            origin = cellView?.convert(firstWallView?.frame ?? CGRect.zero, to: self.boardView).origin
        }
        
        let wall = UIView(frame: CGRect(origin: origin ?? CGPoint.zero, size: CGSize(width: joinWallW, height: joinWallH)))
        wall.backgroundColor = .brown
        
        self.boardView.addSubview(wall)
        
    }
    
    private func addPawn( pawn : Pawn){
        let oldPawn = self.boardView.viewWithTag(pawnTag)
        oldPawn?.removeFromSuperview()
        
        let supportView = self.boardView.viewWithTag(pawn.id)
        
        let point = CGFloat(((supportView?.frame.width ?? 0.0) * 0.80)/8)
        let newX = (supportView?.frame.origin.x ?? 0.0) + point
        let newY = (supportView?.frame.origin.y ?? 0.0) + point
        let newOrigin = CGPoint(x: newX, y: newY)
        let newPawn = UIView(frame: CGRect(origin: newOrigin, size: CGSize(width: (supportView?.frame.width ?? 0.0)*0.60, height: (supportView?.frame.height ?? 0.0)*0.60)))
        newPawn.layer.cornerRadius = newPawn.frame.size.width/2
        newPawn.clipsToBounds = true
        newPawn.tag = pawnTag
        newPawn.backgroundColor = .systemBrown
        
        self.boardView.addSubview(newPawn)

        
    }

    private func createBoard(){
        let boardH = boardView.frame.height
        let boardW = boardView.frame.width
        let cellH = Double(boardH*0.10)
        let cellW = Double(boardW*0.10)
        let barW = Double(cellW)*0.20
        let barH = Double(cellH)*0.20
        var (x,y) = (0.0,0.0)
        
        while (x < 9.0 && y < 9.0) {
            let cell = UIView(frame: CGRect(x: x*cellW, y: y*cellH, width: cellW, height: cellW))
            cell.tag = Int(y*10 + x)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCell(_ : ))))
            cell.backgroundColor = .gray
            cell.isUserInteractionEnabled = true
            
            let rightBar = UIView(frame: CGRect(x: cellW-barW, y: 0, width: barW, height: cellH))
            rightBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCell(_ : ))))
            rightBar.tag = Int(y*10 + x + 100)
            rightBar.backgroundColor = .white
            rightBar.isUserInteractionEnabled = true

            
            let bottomBar = UIView(frame: CGRect(x: 0, y: cellH-barH, width: cellW, height: barH))
            bottomBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCell(_ : ))))
            bottomBar.tag = Int(y*10 + x + 200)
            bottomBar.backgroundColor = .white
            bottomBar.isUserInteractionEnabled = true

            cell.addSubview(rightBar)
            cell.addSubview(bottomBar)
            
            boardView.addSubview(cell)
            x += 1
            if x == 9 {
                x = 0
                y += 1
            }
        }
    }
    
    
    //MARK: Actions
    @objc
    func onTapCell(_ sender: UITapGestureRecognizer){
        guard let tag = sender.view?.tag else { return }
        print("view tapped = \(tag)")
        viewModel?.makeMove(tag: tag)
    }
                                      
    @objc
    func onTapInfo(_ sender: UITapGestureRecognizer){
        viewModel?.showPopup(type: .rules)
    }
                                      
    @objc
    func onTapRestart(_ sender: UITapGestureRecognizer){
        viewModel?.showPopup(type: .restart)
    }
    
    @IBAction func onMovePawnTapped(_ sender: UIButton) {
        viewModel?.setGameState(state: .movePawn)
        
    }
    
    @IBAction func onPickUpWallTapped(_ sender: UIButton) {
        viewModel?.setGameState(state: .pickWall)
    }
    
}

