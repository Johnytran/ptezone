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
        let tmp = self.getParent()
        tmp.reloadAudio()
    }
    @IBAction func skipButton(_ sender: Any) {
        let tmp = self.getParent()
        tmp.skipSession()
    }
    private var parent:UIViewController!
    func setParent(refParent:LisDetailSST){
        self.parent = refParent
    }
    func getParent()->LisDetailSST{
        return self.parent as! LisDetailSST;
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoadingSoundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        }

}
