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
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        grammarDesTextView = UITextView(frame: CGRect(x: 50, y: 0, width: 250.0, height: 100.0))
        grammarDesTextView.contentInsetAdjustmentBehavior = .automatic
        grammarDesTextView.textAlignment = NSTextAlignment.justified
        grammarDesTextView.textColor = UIColor.purple
        grammarDesTextView.backgroundColor = UIColor(red: 255/255.0, green: 197/255.0, blue: 255/255.0, alpha: 1.0)
        grammarDesTextView.layer.cornerRadius = 10
    }
    
    @IBAction func CloseView(_ sender: Any) {
        self.removeFromSuperview()
    }
    func setTextGrammarDes(text: String){
        
        self.grammarDesTextView.text = text
    }
    @IBAction func expandGrammar(_ sender: Any) {
        
        if(self.grammarDesTextView.isDescendant(of: self.expandGrammarView)){
            self.grammarDesTextView.removeFromSuperview()
        }else{
            self.expandGrammarView.addSubview(grammarDesTextView)
            grammarDesTextView.translatesAutoresizingMaskIntoConstraints = false
            grammarDesTextView.leftAnchor.constraint(equalTo: self.expandGrammarView.leftAnchor, constant: 10).isActive = true
            grammarDesTextView.rightAnchor.constraint(equalTo: self.expandGrammarView.rightAnchor, constant: -10).isActive = true
            grammarDesTextView.topAnchor.constraint(equalTo: self.expandGrammarView.topAnchor, constant: 30).isActive = true
            grammarDesTextView.bottomAnchor.constraint(equalTo: self.expandGrammarView.bottomAnchor, constant: -10).isActive = true
            
            
        }
        if(expandGrammarHeight.constant < 200){
            expandGrammarHeight.constant = 200
            
            
        }else{
            expandGrammarHeight.constant = 50
        }
    }
}
