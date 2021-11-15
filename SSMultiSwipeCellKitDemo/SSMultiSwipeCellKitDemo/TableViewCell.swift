//
//  TableViewCell.swift
//  SSMultiSwipeCellKitDemo
//
//  Created by Nishchal Visavadiya on 11/08/21.
//

import UIKit
import SSMultiSwipeCellKit

class TableViewCell: SSTableCell {
    
    @IBOutlet weak var lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cliclk(_: Any) {
        print("clickd \(lbl.text)")
    }

}
