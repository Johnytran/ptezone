//
//  LoadingAudioView.swift
//  PTEzone
//
//  Created by Owner on 26/6/22.
//

import UIKit

class LoadingAudioView: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoadingSoundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        }

}
