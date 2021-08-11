//
//  SSSwipeAction.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 06/07/21.
//

public typealias SSSwipeActionCompletion = (([IndexPath]) -> Void)

import UIKit

public class SSSwipeAction: NSObject {
    
    var completion: SSSwipeActionCompletion? = nil
    public var backgroundColor: UIColor?
    private var label: UILabel?
    private var imageView: UIImageView?
    private let image: UIImage?
    private let text: String?
    private var imageViewHeight: CGFloat!
    private var imageViewWidth: CGFloat!
    public var actionIndicatorViewSize = CGFloat(50)
    var actionIndicatorView = UIView()

    public init(image: UIImage?, text: String?, completion: SSSwipeActionCompletion?) {
        self.image = image
        self.text = text
        self.completion = completion
    }
    
    func makeView(makeforLeading: Bool, emptyView: UIView, for cell: SSTableCell) -> UIView {

        imageViewHeight = cell.frame.height*2 / 3
        imageViewWidth = imageViewHeight
        actionIndicatorView = UIView()
        actionIndicatorViewSize = cell.frame.height
        emptyView.frame = makeforLeading ? CGRect(x: -(2*cell.frame.width), y: 0, width: 2*cell.frame.width, height: cell.frame.height) : CGRect(x: cell.frame.width, y: 0, width: 2*cell.frame.width, height: cell.frame.height)
        
        cell.addSubview(actionIndicatorView)
        addConstraintToActionIndicatorView(leading: makeforLeading, cell: cell)
        
        if image != nil {
            imageView = UIImageView()
            imageView?.image = image
            actionIndicatorView.addSubview(imageView!)
        }
        if text != nil {
            label = UILabel()
            label?.text = text
            label?.textAlignment = .center
            label?.adjustsFontSizeToFitWidth = true
            actionIndicatorView.addSubview(label!)
        }
 
        if imageView == nil && label != nil {
            addConstraintForText(for: cell)
        }
        
        if imageView != nil && label == nil {
            addConstraintForImage(for: cell)
        }
        
        if imageView != nil && label != nil {
            addConstraintForTextImage(for: cell)
        }
        
        actionIndicatorView.alpha = 0
        return actionIndicatorView
    }
    
    private func addConstraintToActionIndicatorView(leading: Bool, cell: SSTableCell) {
        actionIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let actionIndicatorViewHorizontalConstraint = NSLayoutConstraint(item: actionIndicatorView, attribute: leading ? .leading : .trailing, relatedBy: .equal, toItem: cell, attribute: leading ? .leading : .trailing, multiplier: 1, constant: leading ? -actionIndicatorViewSize : actionIndicatorViewSize)
        let actionIndicatorViewVerticalConstraint = NSLayoutConstraint(item: actionIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0)
        let actionIndicatorViewWidthConstraint = NSLayoutConstraint(item: actionIndicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionIndicatorViewSize)
        let actionIndicatorViewHeightConstraint = NSLayoutConstraint(item: actionIndicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionIndicatorViewSize)
        
        NSLayoutConstraint.activate([actionIndicatorViewHorizontalConstraint, actionIndicatorViewVerticalConstraint, actionIndicatorViewWidthConstraint, actionIndicatorViewHeightConstraint])
    }
    
    private func addConstraintForTextImage(for cell: SSTableCell) {
        guard let imageView = imageView, let label = label else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageHorizontalConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: actionIndicatorView, attribute: .top, multiplier: 1, constant: 5)
        let imageVerticalConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
        let imageWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewWidth*5/6)
        let imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewHeight*5/6)
        
        NSLayoutConstraint.activate([imageHorizontalConstraint, imageVerticalConstraint, imageWidthConstraint, imageHeightConstraint])
        
        let labelHorizontalConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: actionIndicatorView, attribute: .bottom, multiplier: 1, constant: 0)
        let labelVerticalConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
        let labelWidthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionIndicatorViewSize)
        let labeleHeightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewHeight/2)
        
        NSLayoutConstraint.activate([labelHorizontalConstraint, labelVerticalConstraint, labelWidthConstraint, labeleHeightConstraint])
    }
    
    private func addConstraintForText(for cell: SSTableCell) {
        guard let label = label else { return }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelHorizontalConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
        let labelVerticalConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
        let labelWidthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cell.frame.height)
        let labeleHeightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cell.frame.height)
        
        NSLayoutConstraint.activate([labelHorizontalConstraint, labelVerticalConstraint, labelWidthConstraint, labeleHeightConstraint])
    }
    
    private func addConstraintForImage(for cell: SSTableCell) {
        guard let imageView = imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let imageHorizontalConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
        let imageVerticalConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: actionIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
        let imageWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewWidth)
        let imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewHeight)
        
        NSLayoutConstraint.activate([imageHorizontalConstraint, imageVerticalConstraint, imageWidthConstraint, imageHeightConstraint])
    }

}
