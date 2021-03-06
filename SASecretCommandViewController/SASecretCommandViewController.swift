//
//  SASecretCommandViewController.swift
//  SASecretCommandViewController
//
//  Created by 鈴木大貴 on 2015/02/07.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public class SASecretCommandViewController: UIViewController {

    private let commandManager = SASecretCommandManager()
    
    private var buttonView: SASecreatCommandButtonView?
    private var keyView: SASecretCommandKeyView?
    
    public var showInputCommand = false
    
    private var upGesture: UISwipeGestureRecognizer?
    private var downGesture: UISwipeGestureRecognizer?
    private var leftGesture: UISwipeGestureRecognizer?
    private var rightGesture: UISwipeGestureRecognizer?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commandManager.delegate = self
        addGesture()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addGesture() {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(SASecretCommandViewController.detectSwipeGesture(_:)))
        upGesture.direction = .Up
        view.addGestureRecognizer(upGesture)
        self.upGesture = upGesture
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(SASecretCommandViewController.detectSwipeGesture(_:)))
        downGesture.direction = .Down
        view.addGestureRecognizer(downGesture)
        self.downGesture = downGesture
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(SASecretCommandViewController.detectSwipeGesture(_:)))
        rightGesture.direction = .Right
        view.addGestureRecognizer(rightGesture)
        self.rightGesture = rightGesture
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(SASecretCommandViewController.detectSwipeGesture(_:)))
        leftGesture.direction = .Left
        view.addGestureRecognizer(leftGesture)
        self.leftGesture = leftGesture
    }
    
    private func removeGesture() {
        if let upGesture = upGesture {
            view.removeGestureRecognizer(upGesture)
        }
        
        if let downGesture = downGesture {
            view.removeGestureRecognizer(downGesture)
        }
        
        if let leftGesture = leftGesture {
            view.removeGestureRecognizer(leftGesture)
        }
        
        if let rightGesture = rightGesture {
            view.removeGestureRecognizer(rightGesture)
        }
    }
    
    private func createButtonView() -> SASecreatCommandButtonView {
        let buttonView = SASecreatCommandButtonView(frame: view.bounds)
        buttonView.delegate = self
        return buttonView
    }
    
    private func removeButtonView() -> Bool {
        if let buttonView = buttonView {
            buttonView.removeFromSuperview()
            addGesture()
            return true
        }
        return false
    }
    
//    private func showButtonView() {
//        
//        self.buttonView = self.createButtonView()
//        self.buttonView.alpha = 0.0
//        self.buttonView.transform = CGAffineTransformMakeScale(1.2, 1.2)
//        self.view.addSubview(self.buttonView)
//        self.removeGesture()
//        
//        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
//            
//            self.buttonView.alpha = 1.0
//            self.buttonView.transform = CGAffineTransformIdentity
//
//        }, completion: { (finished) in
//            
//        })
//    }
//    
//    private func hideButtonView() {
//        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
//            
//            self.buttonView.alpha = 0.0
//            self.buttonView.transform = CGAffineTransformMakeScale(0.8, 0.8)
//            
//        }, completion: { (finished) in
//            
//            self.buttonView?.removeFromSuperview()
//            self.addGesture()
//            
//        })
//    }
    
    private func createKeyView(commandType: SASecretCommandType) -> SASecretCommandKeyView {
        let keyView = SASecretCommandKeyView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        keyView.center = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
        keyView.commandType = commandType
        return keyView
    }
    
    private func removeKeyView() {
        keyView?.removeFromSuperview()
    }
    
    private func showKeyView(command: SASecretCommandType) {
        if showInputCommand {
            self.keyView?.removeFromSuperview()
            
            let keyView = createKeyView(command)
            keyView.alpha = 0.0
            view.addSubview(keyView)
            self.keyView = keyView
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                keyView.alpha = 1.0
            }, completion: { (finished) in
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    keyView.alpha = 0.0
                }, completion: { (finished) in
                    self.removeKeyView()
                })
            })
        }
    }
    
    func detectSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard let crossKeyCommand = SASecretCommandType.convert(gesture.direction) else {
            return
        }
        commandManager.checkCommand(crossKeyCommand)
        showKeyView(crossKeyCommand)
    }
    
    public func registerSecretCommand(commandList: [SASecretCommandType]) {
        if commandList.count > 0 {
            if let command = commandList.first {
                switch command {
                    case .A, .B:
                        let buttonView = createButtonView()
                        removeGesture()
                        view.addSubview(buttonView)
                        self.buttonView = buttonView
                    case .Up, .Down, .Left, .Right:
                        break
                }
            }
        }
        
        commandManager.secretCommandList = commandList
    }
    
    public func secretCommandPassed() {}
}

extension SASecretCommandViewController: SASecretCommandManagerDelegate {
    func secretCommandManagerShowButtonView(manager: SASecretCommandManager) {
        if !removeButtonView() {
            buttonView = createButtonView()
        }
        
        removeGesture()
        if let buttonView = buttonView {
            view.addSubview(buttonView)
        }
    }
    
    func secretCommandManagerCloseButtonView(manager: SASecretCommandManager) {
        removeButtonView()
    }
    
    func secretCommandManagerSecretCommandPassed(manager: SASecretCommandManager) {
        removeButtonView()
        secretCommandPassed()
    }
}

extension SASecretCommandViewController: SASecreatCommandButtonViewDelegate {
    func secretCommandButtonViewAButtonTapped(buttonView: SASecreatCommandButtonView) {
        commandManager.checkCommand(.A)
        
        showKeyView(.A)
    }
    
    func secretCommandButtonViewBButtonTapped(buttonView: SASecreatCommandButtonView) {
        commandManager.checkCommand(.B)
        
        showKeyView(.B)
    }
}
