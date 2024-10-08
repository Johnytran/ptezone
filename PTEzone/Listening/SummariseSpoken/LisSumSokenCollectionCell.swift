//
//  LisSumSokenCells.swift
//  PTEzone
//
//  Created by Tuan Anh on 14/3/2024.
//
// https://github.com/lygon55555/neumorphic-view

import SwiftUI

class LisSumSokenCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var imgSkill: UIImageView!
    @IBOutlet weak var neuView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: YourCellDelegate?
    
    private var idChoose:Int = 0
    
    func setIDChoose(newID:Int){
        self.idChoose = newID
    }
    func getIDChoose()->Int{
        return self.idChoose
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func OpenSkill(_ sender: Any) {
        var segString:String
        switch self.idChoose {
        case 0:
            segString = "SummariseLisSegue"
        default:
            segString = ""
        }
        if(!segString.isEmpty){
            delegate?.buttonPressed(segName: segString)
        }
            
    }
}

protocol YourCellDelegate {
    func buttonPressed(segName:String)
}
