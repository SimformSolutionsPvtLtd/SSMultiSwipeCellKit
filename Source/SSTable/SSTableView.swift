//
//  SSTableView.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 06/07/21.
//

import UIKit

open class SSTableView: UITableView {
    
    // MARK: Public variables
    
    public let firstSwipeThreshold = CGFloat(0)
    public var secondSwipeThreshold = CGFloat(40)
    public var thirdSwipeThreshold = CGFloat(70)
    public var cellDetectionPrecesion = 2 // pixels
    
    // MARK: Private variables
    
    private var swipeFirstContactPointInTableView = CGPoint()
    private var swipeFirstContactPointInParentView = CGPoint()
    private var swipeFirstContactIndexPath = IndexPath(row: 0, section: 0)
    private var previousIndexPaths = Set<IndexPath>()
    private var selectedIndexPaths = Set<IndexPath>()
    private var percentCellHeighDragDown = CGFloat(30)
    private var percentCellHeighDragUp = CGFloat(70)
    private var downScrollThreshold = CGFloat(30)
    private var upScrollThreshold = CGFloat(30)
    private var previousChangeInLocation = CGPoint()
    private var locationInTableView =  CGPoint()
    private var locationInParentView =  CGPoint()
    private var translationInTableView =  CGPoint()
    private var translationInParentView =  CGPoint()
    private var velocity =  CGPoint()
    private var xSwipePercentage = CGFloat()
    private var ySwipePercentage = CGFloat()
    private var maxIndex = -1
    private var leadinActions: Bool = true
    private var indexPaths = Set<IndexPath>()
    private let completionEndDelay = 0.6

    internal func gesture(_ gestureRecognizer: UIPanGestureRecognizer) {

        locationInTableView = gestureRecognizer.location(in: self)
        locationInParentView = gestureRecognizer.location(in: superview)
        translationInTableView = gestureRecognizer.translation(in: self)
        translationInParentView = gestureRecognizer.translation(in: superview)
        velocity = gestureRecognizer.velocity(in: self)
        xSwipePercentage = ( translationInTableView.x / self.frame.width ) * 100
        ySwipePercentage = ( translationInParentView.y / self.frame.height ) * 100

        indexPaths = Set<IndexPath>()
        switch gestureRecognizer.state {
        
            case .began:
                installMovingViews()
                if let cell = self.cellForRow(at: swipeFirstContactIndexPath) as? SSTableCell {
                    cell.slideActionsBack(leading: true)
                    cell.slideActionsBack(leading: false)
                }
                swipeFirstContactPointInTableView = locationInTableView
                swipeFirstContactPointInParentView = locationInParentView
                if let indexPath = self.indexPathForRow(at: locationInTableView) {
                    swipeFirstContactIndexPath = indexPath
                    maxIndex = self.numberOfRows(inSection: swipeFirstContactIndexPath.section) - 1
                }
                previousIndexPaths = Set<IndexPath>()
                previousChangeInLocation = locationInTableView
                leadinActions = gestureRecognizer.velocity(in: self).x > 0
                
            case .changed:
                
                if (swipeFirstContactPointInTableView.x > locationInTableView.x && leadinActions) {
                    slideCellsBack(leading: true, indexPaths: previousIndexPaths)
                    break
                } else if (swipeFirstContactPointInTableView.x < locationInTableView.x && !leadinActions) {
                    slideCellsBack(leading: false, indexPaths: previousIndexPaths)
                    break
                }

                if xSwipePercentage < -thirdSwipeThreshold {
                    /// trailing options
                    /// third swipe action ( if exists othewise second swipe)
                    singleOptionRevealer(leading: false, index: 0)
                    
                } else if xSwipePercentage >= -thirdSwipeThreshold && xSwipePercentage < -secondSwipeThreshold {
                    /// trailing options
                    /// second swipe action ( if exists othewise first swipe)
                    singleOptionRevealer(leading: false, index: 1)
                    
                } else if xSwipePercentage >= -secondSwipeThreshold && xSwipePercentage < -firstSwipeThreshold {
                    /// trailing options
                    /// first swipe action ( if exists othewise do nothing)
                    singleOptionRevealer(leading: false, index: 2)
                    
                } else if xSwipePercentage >= -firstSwipeThreshold && xSwipePercentage < 0 {
                    /// trailing options
                    /// reveal
                    
                } else if xSwipePercentage >= 0 && xSwipePercentage < firstSwipeThreshold {
                    /// leading options
                    /// reveal
                    
                } else if xSwipePercentage >= firstSwipeThreshold && xSwipePercentage < secondSwipeThreshold {
                    /// leading options
                    /// first swipe action ( if exists othewise do nothing)
                    singleOptionRevealer(leading: true, index: 2)
                    
                } else if xSwipePercentage >= secondSwipeThreshold && xSwipePercentage < thirdSwipeThreshold {
                    /// leading options
                    /// second swipe action ( if exists othewise first swipe)
                    singleOptionRevealer(leading: true, index: 1)
                } else if xSwipePercentage >= thirdSwipeThreshold {
                    /// leading options
                    /// third swipe action ( if exists othewise second swipe)
                    singleOptionRevealer(leading: true, index: 0)
                }
                previousIndexPaths = indexPaths
                previousChangeInLocation = locationInTableView
                
            case .ended:
                
                if ( (swipeFirstContactPointInTableView.x > locationInTableView.x && leadinActions) || (velocity.x < 0 && leadinActions ) ) {
                    slideCellsBack(leading: true, indexPaths: previousIndexPaths)
                    self.uninstallMovingViews()
                    break
                } else if ( (swipeFirstContactPointInTableView.x < locationInTableView.x && !leadinActions) || (velocity.x > 0 && !leadinActions )) {
                    slideCellsBack(leading: false, indexPaths: previousIndexPaths)
                    self.uninstallMovingViews()
                    break
                }

                if xSwipePercentage < -thirdSwipeThreshold {
                    /// trailing options
                    /// third swipe action ( if exists othewise second swipe)
                    slideCellsBackWithEffect(leading: false, index: 0)
                    callCompletionHandlers(indexPaths: previousIndexPaths, index: 0, leading: false)
                    
                } else if xSwipePercentage >= -thirdSwipeThreshold && xSwipePercentage < -secondSwipeThreshold {
                    /// trailing options
                    /// second swipe action ( if exists othewise first swipe)
                    slideCellsBackWithEffect(leading: false, index: 1)
                    callCompletionHandlers(indexPaths: previousIndexPaths, index: 1, leading: false)
                    
                } else if xSwipePercentage >= -secondSwipeThreshold && xSwipePercentage < -firstSwipeThreshold {
                    /// trailing options
                    /// first swipe action ( if exists othewise do nothing)
                    slideCellsBackWithEffect(leading: false, index: 2)
                    callCompletionHandlers(indexPaths: previousIndexPaths, index: 2, leading: false)
                    
                } else if xSwipePercentage >= -firstSwipeThreshold && xSwipePercentage < 0 {
                    /// trailing options
                    /// reveal
                    
                } else if xSwipePercentage >= 0 && xSwipePercentage < firstSwipeThreshold {
                    /// leading options
                    /// reveal
                    
                } else if xSwipePercentage >= firstSwipeThreshold && xSwipePercentage < secondSwipeThreshold {
                    /// leading options
                    /// first swipe action ( if exists othewise do nothing)
                    slideCellsBackWithEffect(leading: true, index: 2)
                    self.callCompletionHandlers(indexPaths: self.previousIndexPaths, index: 2, leading: true)
                    
                } else if xSwipePercentage >= secondSwipeThreshold && xSwipePercentage < thirdSwipeThreshold {
                    /// leading options
                    /// second swipe action ( if exists othewise first swipe)
                    slideCellsBackWithEffect(leading: true, index: 1)
                    self.callCompletionHandlers(indexPaths: self.previousIndexPaths, index: 1, leading: true)
                    
                } else if xSwipePercentage >= thirdSwipeThreshold {
                    /// leading options
                    /// third swipe action ( if exists othewise second swipe)
                    slideCellsBackWithEffect(leading: true, index: 0)
                    self.callCompletionHandlers(indexPaths: self.previousIndexPaths, index: 0, leading: true)
                }
                self.uninstallMovingViews()

            case .possible, .cancelled, .failed:
                    break
                    
            @unknown default:
                break
        }
    }
    
    private func callCompletionHandlers(indexPaths: Set<IndexPath>, index: Int, leading: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + completionEndDelay) {
            if let cell = self.cellForRow(at: self.swipeFirstContactIndexPath) as? SSTableCell {
                cell.completionHandler(indexPaths: indexPaths, index: index, leading: leading)
            }
        }
    }
    
    private func slideCellsWithActions(leading: Bool, translationX: CGFloat, indexPaths: Set<IndexPath>) {
        for index in indexPaths {
            if let cell = self.cellForRow(at: index) as? SSTableCell {
                cell.slideCellAndActions(leading: leading, translationX: translationX)
            }
        }
    }
    
    
    private func slideCellsBack(leading : Bool, indexPaths: Set<IndexPath>) {
        for index in indexPaths {
            if let cell = self.cellForRow(at: index) as? SSTableCell {
                cell.slideActionsBack(leading: leading)
            }
        }
    }
    
    private func spanOneActionOnCells(leading: Bool, i: Int, translationX: CGFloat, velocity: CGPoint, indexPaths: Set<IndexPath>) {
        for index in indexPaths {
            if let cell = self.cellForRow(at: index) as? SSTableCell {
                cell.spanOneAction(leadingAction: leading, index: i, translationX: translationX, velocity: velocity)
            }
        }
    }
    
    private func slideCellsBackWithEffect(leading: Bool, index: Int) {
        for indx in previousIndexPaths {
            if let cell = self.cellForRow(at: indx) as? SSTableCell {
                cell.slideBackActionsWithEfect(leading: leading, index: index)
            }
        }
    }
 
    private func singleOptionRevealer(leading: Bool, index: Int) {
        setIndexPaths()
        slideCellsBack(leading: leading, indexPaths: previousIndexPaths.subtracting(indexPaths))
        spanOneActionOnCells(leading: leading, i: index, translationX: translationInTableView.x, velocity: velocity, indexPaths: indexPaths)
    }

    private func setIndexPaths() {
        let steps = ySwipePercentage > 0 ? -cellDetectionPrecesion : cellDetectionPrecesion
        let locationsToCheck = Array(stride(from: locationInTableView.y, through: swipeFirstContactPointInTableView.y, by: CGFloat(steps)))
        for location in locationsToCheck {
            if let indexPath = self.indexPathForRow(at: CGPoint(x: self.frame.midX, y: location)) {
                indexPaths.insert(indexPath)
            }
        }
        if ySwipePercentage > 0 {
            if let lastRowIndexPath = self.indexPathForRow(at: locationInTableView) {
                if let cell = self.cellForRow(at: lastRowIndexPath) {
                    let percent = ( locationInTableView.y - cell.frame.minY ) / cell.frame.height * 100
                    if percent < percentCellHeighDragDown && swipeFirstContactIndexPath != lastRowIndexPath {
                        indexPaths.remove(lastRowIndexPath)
                    }
                }
            }
        } else {
            if let lastRowIndexPath = self.indexPathForRow(at: locationInTableView) {
                if let cell = self.cellForRow(at: lastRowIndexPath) {
                    let percent = ( cell.frame.maxY - locationInTableView.y ) / cell.frame.height * 100
                    if percent < percentCellHeighDragUp && swipeFirstContactIndexPath != lastRowIndexPath {
                        indexPaths.remove(lastRowIndexPath)
                    }
                }
            }
        }
    }
    
    private func installMovingViews() {
        for index in getAllIndexPath() {
            if let cell = self.cellForRow(at: index) as? SSTableCell {
                cell.installMovingView()
            }
        }
    }
    
    private func uninstallMovingViews() {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + completionEndDelay) { [weak self] in
            guard let `self` = self else { return }
            self.isUserInteractionEnabled = true
            for index in self.getAllIndexPath() {
                if let cell = self.cellForRow(at: index) as? SSTableCell {
                    cell.uninstallMovingView()
                }
            }
        }
    }
    
    private func getAllIndexPath() -> Set<IndexPath> {
        var indexPaths = Set<IndexPath>()
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                indexPaths.insert(IndexPath(row: row, section: section))
            }
        }
        return indexPaths
    }
    
}
