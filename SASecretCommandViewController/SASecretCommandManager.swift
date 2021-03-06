//
//  SASecretCommandManager.swift
//  SASecretCommandViewController
//
//  Created by 鈴木大貴 on 2015/02/07.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public enum SASecretCommandType: String {
    case Up = "Up"
    case Down = "Down"
    case Left = "Left"
    case Right = "Right"
    case A = "A"
    case B = "B"
    
    static func convert(direction: UISwipeGestureRecognizerDirection) -> SASecretCommandType? {
        switch direction {
            case UISwipeGestureRecognizerDirection.Right:
                return .Right
            case UISwipeGestureRecognizerDirection.Left:
                return .Left
            case UISwipeGestureRecognizerDirection.Down:
                return .Down
            case UISwipeGestureRecognizerDirection.Up:
                return .Up
            default:
                return nil
        }
    }
}

protocol SASecretCommandManagerDelegate: class {
    func secretCommandManagerShowButtonView(manager: SASecretCommandManager)
    func secretCommandManagerCloseButtonView(manager: SASecretCommandManager)
    func secretCommandManagerSecretCommandPassed(manager: SASecretCommandManager)
}

class SASecretCommandManager: NSObject {
    
    private var commandStack = [SASecretCommandType]()
    var secretCommandList: [SASecretCommandType]?
    weak var delegate: SASecretCommandManagerDelegate?

    func checkCommand(command: SASecretCommandType) {
        let index = commandStack.count
        
        if let secretCommandList = secretCommandList {
            if (index > secretCommandList.count - 1) {
                commandStack.removeAll(keepCapacity: false)
                return
            }
            
            if let secretCommand = self.secretCommandList?[index] {
                if secretCommand == command {
                    commandStack.append(command)
                    
                    if let nextCommand = secretCommandList.next(index) {
                        switch nextCommand {
                            case .A, .B:
                                delegate?.secretCommandManagerShowButtonView(self)
                            case .Up, .Down, .Left, .Right:
                                delegate?.secretCommandManagerCloseButtonView(self)
                        }
                    }
                } else {
                    if index > 0 {
                        commandStack.removeAll(keepCapacity: false)
                        
                        if let secretCommand = secretCommandList.first {
                            if secretCommand == command {
                                commandStack.append(command)
                            }
                        }
                        
                        if let nextCommand = secretCommandList.next(0) {
                            switch nextCommand {
                                case .A, .B:
                                    delegate?.secretCommandManagerShowButtonView(self)
                                case .Up, .Down, .Left, .Right:
                                    delegate?.secretCommandManagerCloseButtonView(self)
                            }
                        }
                        
                        return
                    }
                }
            }
            
            if commandStack.count == secretCommandList.count {
                for (index, secretCommand) in secretCommandList.enumerate() {
                    if (secretCommand != self.commandStack[index]) {
                        return
                    }
                }
                
                delegate?.secretCommandManagerSecretCommandPassed(self)
                commandStack.removeAll(keepCapacity: false)
            }
        }
    }
}

private extension Array {
    private func hasNext(index: Int) -> Bool {
        return count > index + 1
    }
    
    func next(index: Int) -> Element? {
        if hasNext(index) {
            return self[index + 1]
        }
        return nil
    }
}
