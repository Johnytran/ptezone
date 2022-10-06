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
    private var grammarDesTextView:UITextView!
    
    @IBAction func CloseView(_ sender: Any) {
        self.removeFromSuperview()
    }
    func setTextGrammarDes(text: String){
        self.grammarDesTextView.text = text
    }
    @IBAction func expandGrammar(_ sender: Any) {
        grammarDesTextView = UITextView(frame: CGRect(x: 50, y: 0, width: 250.0, height: 100.0))
        grammarDesTextView.contentInsetAdjustmentBehavior = .automatic
        grammarDesTextView.center = self.expandGrammarView.center
        grammarDesTextView.textAlignment = NSTextAlignment.justified
        grammarDesTextView.textColor = UIColor.purple
        grammarDesTextView.backgroundColor = UIColor.systemPink
        
        self.expandGrammarView.addSubview(grammarDesTextView)
        
        grammarDesTextView.translatesAutoresizingMaskIntoConstraints = false
        grammarDesTextView.leftAnchor.constraint(equalTo: self.expandGrammarView.leftAnchor, constant: 10).isActive = true
        grammarDesTextView.rightAnchor.constraint(equalTo: self.expandGrammarView.rightAnchor, constant: -10).isActive = true
        grammarDesTextView.topAnchor.constraint(equalTo: self.expandGrammarView.topAnchor, constant: 30).isActive = true
        grammarDesTextView.bottomAnchor.constraint(equalTo: self.expandGrammarView.bottomAnchor, constant: -10).isActive = true
        
        
        if(expandGrammarHeight.constant < 200){
            expandGrammarHeight.constant = 200
            
            
        }else{
            expandGrammarHeight.constant = 50
        }
    }
}
