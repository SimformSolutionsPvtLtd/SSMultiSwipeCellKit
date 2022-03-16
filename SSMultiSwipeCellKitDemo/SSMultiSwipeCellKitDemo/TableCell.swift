//
//  TableCell.swift
//  SSMultiSwipeCellKitDemo
//
//  Created by Nishchal Visavadiya on 26/11/21.
//

import UIKit
import SSMultiSwipeCellKit
import Kingfisher

class TableCell: SSTableCell {

    // MARK: @IBOutlet
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: override
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: config
    
    func configureCell(data: Data) {
        mainTitleLabel.text = data.mainTitle
        subTitleLabel.text = data.subTitle
        descriptionLabel.text = data.descripttion
        logoImageView.kf.setImage(with: URL(string: data.imageUrlString))
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
    }
    
}
