//
//  SSTableCell.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 06/07/21.
//

import UIKit

public protocol SSTableCellDelegate {
    func leadingSwipeActions(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration?
    func trailingSwipeActions(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration?
}


open class SSTableCell: UITableViewCell {
    
    // MARK: Public variables
    
    public var delegate: SSTableCellDelegate? {
        didSet {
            addPanSwipeGestureRecognizer()
        }
    }

    // MARK: Private variables
    
    internal var leadingSwipeActions: [SSSwipeAction]?
    internal var trailingSwipeActions: [SSSwipeAction]?
    private var tableView: SSTableView?
    private var mutliSelectRecognizer: UIPanGestureRecognizer?
    private let panDelegate = SSPanController()
    private var movingContentView = UIView()
    private var leadingMovingView = UIView()
    private var trailingMovingView = UIView()
    private var bounceBackOnCompletion = CGFloat(8)
    private var viewsTobeRemoved = [UIView]()
    private var indexPath: IndexPath? {
        get {
            tableView?.indexPath(for: self)
        }
    }
    private func addPanSwipeGestureRecognizer() {
        if let gesture = mutliSelectRecognizer {
            self.removeGestureRecognizer(gesture)
        }
        mutliSelectRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gesture(_:)))
        mutliSelectRecognizer?.delegate = panDelegate
        panDelegate.delegate = self
        if let gesture = mutliSelectRecognizer {
            addGestureRecognizer(gesture)
        }
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds  = true // need this as if table view is in grouped insets then added subvies needs to be clipped to the cell
        uninstallMovingView()
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        var view: UIView = self
        while let superview = view.superview {
            view = superview

            if let tableView = view as? SSTableView {
                self.tableView = tableView
                return
            }
        }
    }
    
    @objc private func gesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        tableView?.gesture(gestureRecognizer)
    }
    
    internal func slideCellAndActions(leading: Bool, translationX: CGFloat) {
        guard let actions = leading ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        let movingView = leading ? leadingMovingView : trailingMovingView
        if totalActions == 0 {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 20, options: .curveEaseOut, animations: {
            self.movingContentView.transform = CGAffineTransform(translationX: translationX*CGFloat(totalActions)/2, y: 0)
            movingView.transform = CGAffineTransform(translationX: translationX/2, y: 0)
        }, completion: {(success) in
        })
    }
    
    internal func slideActionsBack(leading: Bool) {
        guard let actions = leading ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        let movingView = leading ? leadingMovingView : trailingMovingView
        if totalActions < 0 {
            return
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.movingContentView.transform = .identity
            movingView.transform = .identity
            for action in actions {
                action.actionIndicatorView.transform = .identity
                action.actionIndicatorView.alpha = 0
            }
        }, completion: {(success) in
            
        })
    }
    
    internal func slideBackActionsWithEfect(leading: Bool, index: Int) {
        guard let actions = leading ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        let movingView = leading ? leadingMovingView : trailingMovingView
        if totalActions == 0 {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
            let transformation = CGAffineTransform(translationX: leading ? 2*self.frame.width : -2*self.frame.width, y: 0)
            self.movingContentView.transform = transformation
            movingView.transform = transformation
        }, completion: { _ in
            self.movingContentView.transform = .identity
            movingView.transform = .identity
            actions[index].actionIndicatorView.transform = .identity
            actions[index].actionIndicatorView.alpha = 0
            movingView.backgroundColor = .none
        })
    }
    
    internal func spanOneAction(leadingAction: Bool, index: Int, translationX: CGFloat, velocity: CGPoint) {
        guard let actions = leadingAction ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        let movingView = leadingAction ? leadingMovingView : trailingMovingView
        var indexToSpan = index
        if index > totalActions-1 {
            indexToSpan = totalActions-1
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.movingContentView.transform = CGAffineTransform(translationX: translationX, y: 0)
            movingView.transform = CGAffineTransform(translationX: translationX, y: 0)
            for i in 0..<totalActions {
                if i == indexToSpan {
                    let actionIndicatorTransformation = leadingAction ? translationX > actions[i].actionIndicatorViewSize+actions[i].actionIndicatorIconOffset ? actions[i].actionIndicatorViewSize+actions[i].actionIndicatorIconOffset : translationX-actions[i].actionIndicatorIconOffset : translationX > -actions[i].actionIndicatorViewSize-actions[i].actionIndicatorIconOffset ? translationX+actions[i].actionIndicatorIconOffset : -actions[i].actionIndicatorViewSize-actions[i].actionIndicatorIconOffset
                    movingView.backgroundColor = actions[i].backgroundColor
                    actions[i].actionIndicatorView.transform = CGAffineTransform(translationX: actionIndicatorTransformation, y: 0)
                    actions[i].actionIndicatorView.alpha = 1
                } else {
                    actions[i].actionIndicatorView.transform = .identity
                    actions[i].actionIndicatorView.alpha = 0
                }
            }
        }, completion: {(success) in
        })
    }
    
    internal func completionHandler(indexPaths: Set<IndexPath>,index: Int, leading: Bool) {
        guard let actions = leading ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        if totalActions == 0 || indexPaths.isEmpty {
            return
        }
        var indexToCall = index
        if index > totalActions-1 {
            indexToCall = totalActions-1
        }
        actions[indexToCall].completion?(Array(indexPaths).sorted(by: { $0.row > $1.row }))
    }
    
    internal func revealSwpieOptions(leading: Bool, velocity: CGPoint) {
        let uniformWidthToreveal = 60
        let movingView = leading ? leadingMovingView : trailingMovingView
        guard let actions = leading ? leadingSwipeActions : trailingSwipeActions else { return }
        let totalActions = actions.count
        if totalActions == 0 {
            return
        }
        let translationX = CGFloat(totalActions) * CGFloat(uniformWidthToreveal) * (leading ? 1 : -1)
        UIView.animate(withDuration: TimeInterval(CGFloat(velocity.x/10000)) + 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: velocity.x/45, options: .curveEaseIn, animations: {
            movingView.transform = CGAffineTransform(translationX: translationX + CGFloat( uniformWidthToreveal * 0 * (leading ? -1 : 1) ), y: 0)
            self.movingContentView.transform = CGAffineTransform(translationX: translationX, y: 0)
        }, completion: {(success) in
        })
    }
    
    internal func installMovingView() {
        guard let delegate = delegate else { return }
        guard let indexPath = indexPath else { return }
        guard let tableView = tableView else { return }
        
        viewsTobeRemoved = [UIView]()
        movingContentView = UIView()
        leadingMovingView = UIView()
        trailingMovingView = UIView()
        movingContentView.addSubview(contentView)
        viewsTobeRemoved.append(movingContentView)
        addSubview(movingContentView)
        
        if let actions = delegate.leadingSwipeActions(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)?.actions {
            leadingSwipeActions = actions
            addSubview(leadingMovingView)
            viewsTobeRemoved.append(leadingMovingView)
            for i in 0..<actions.count {
                let createdView = actions[i].makeView(makeforLeading: true, emptyView: leadingMovingView, for: self)
                viewsTobeRemoved.append(createdView)
            }
        }
        
        if let actions = delegate.trailingSwipeActions(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)?.actions {
            trailingSwipeActions = actions
            addSubview(trailingMovingView)
            viewsTobeRemoved.append(trailingMovingView)
            for i in 0..<actions.count {
                let createdView = actions[i].makeView(makeforLeading: false, emptyView: trailingMovingView, for: self)
                viewsTobeRemoved.append(createdView)
            }
        }
        
    }
    
    internal func uninstallMovingView() {
        for view in subviews {
            if viewsTobeRemoved.contains(view) {
                view.removeFromSuperview()
            }
        }
        
        leadingSwipeActions = nil
        trailingSwipeActions = nil
        self.addSubview(self.contentView)
    }

}

extension SSTableCell: SSPanControllerDelegate {
    
    public func slideRevealedCellsBack() {
        self.slideActionsBack(leading: true)
        self.slideActionsBack(leading: false)
    }

}
