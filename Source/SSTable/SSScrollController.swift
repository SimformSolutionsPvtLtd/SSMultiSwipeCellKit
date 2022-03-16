//
//  SSScrollController.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 13/07/21.
//

import UIKit

class SSScrollController: NSObject, UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        debugPrint("ended")
    }
}
