//
//  ViewController.swift
//  PTEzone
//
//  Created by Owner on 9/5/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let colorNormal : UIColor = UIColor.black
        let colorSelected : UIColor = UIColor(red: 235/255.0, green: 12/255.0, blue: 109/255.0, alpha: 1.0)
        let titleFontAll : UIFont = UIFont(name: "American Typewriter", size: 13.0)!

        let attributesNormal = [
            NSAttributedString.Key.foregroundColor : colorNormal,
            NSAttributedString.Key.font : titleFontAll
        ]

        let attributesSelected = [
            NSAttributedString.Key.foregroundColor : colorSelected,
            NSAttributedString.Key.font : titleFontAll
        ]

        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)

    }


}

