//
//  LisSumSokenCells.swift
//  PTEzone
//
//  Created by Tuan Anh on 14/3/2024.
//

import UIKit

class LisSumSokenCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 2)
        self.layer.shadowRadius = 10
        
        
    }
    
}
