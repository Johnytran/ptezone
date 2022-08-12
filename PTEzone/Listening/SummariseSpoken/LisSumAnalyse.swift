//
//  LisSumAnalyse.swift
//  PTEzone
//
//  Created by Owner on 7/8/22.
//

import UIKit

class LisSumAnalyse: UIView {

    @IBOutlet weak var progContent: KDCircularProgress!
    
    @IBOutlet weak var progGrammar: KDCircularProgress!
    @IBOutlet weak var progForm: KDCircularProgress!
    
    
    @IBAction func CloseView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
