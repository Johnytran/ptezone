//
//  LoadingAudioView.swift
//  PTEzone
//
//  Created by Owner on 26/6/22.
//

import UIKit

class LoadingAudioView: UIView {

    @IBOutlet weak var msgLabel: UILabel!
    @IBAction func reloadButton(_ sender: Any) {
    }
    @IBAction func skipButton(_ sender: Any) {
        //self.parent.skipSession();
    }
//    private var parent = LisDetailSST()
//    func getParent(refParent:LisDetailSST){
//        self.parent = refParent
//    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoadingSoundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        }

}
