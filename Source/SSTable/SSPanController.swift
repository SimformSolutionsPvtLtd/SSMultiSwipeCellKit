//
//  SSPanController.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 08/07/21.
//

import UIKit

protocol SSPanControllerDelegate {
    func slideRevealedCellsBack()
}

class SSPanController: NSObject, UIGestureRecognizerDelegate {
    
    var delegate: SSPanControllerDelegate?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let view = gestureRecognizer.view
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            if abs(gesture.translation(in: view).x) > abs(gesture.translation(in: view).y) {
                return true
            }
        }
        delegate?.slideRevealedCellsBack()
        return false
    }
    
}
