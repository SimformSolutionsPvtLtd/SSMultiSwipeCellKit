//
//  SSSwipeConfiguration.swift
//  SSCellKit
//
//  Created by Nishchal Visavadiya on 06/07/21.
//

import UIKit

public class SSSwipeConfiguration: NSObject {
    
    var actions: [SSSwipeAction]
    
    public init(actions: [SSSwipeAction]) {
        if actions.count > 3 {
            fatalError("SSSwipeConfiguration can have max 3 actions")
        }
        self.actions = actions
    }
    
}
