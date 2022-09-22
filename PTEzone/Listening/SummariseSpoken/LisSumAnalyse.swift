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
    
    @IBOutlet weak var expandGrammarHeight: NSLayoutConstraint!
    @IBOutlet weak var expandGrammarView: UIView!
    
    @IBAction func CloseView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func expandGrammar(_ sender: Any) {
//        let textView = UITextView(frame: CGRect(x: 50, y: 0, width: 250.0, height: 100.0))
//        textView.contentInsetAdjustmentBehavior = .automatic
//        textView.center = self.view.center
//        textView.textAlignment = NSTextAlignment.justified
//        textView.textColor = UIColor.blue
//        textView.backgroundColor = UIColor.lightGray
        
        if(expandGrammarHeight.constant < 200){
            expandGrammarHeight.constant = 200
        }else{
            expandGrammarHeight.constant = 50
        }
    }
}
