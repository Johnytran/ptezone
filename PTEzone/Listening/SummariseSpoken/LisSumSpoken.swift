//
//  File.swift
//  PTEzone
//
//  Created by Tuan Anh on 14/3/2024.
//

import UIKit

class LisSumSpoken: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let reuseIdentifier = "liscell" // also enter this string as the cell identifier in the storyboard
    var items = ["Summarize Spoken Text", 
                 "Fill In The Blank",
                 "MC, Choose Single Answer",
                 "MC, Choose Multiple Answer",
                 "Highlight Correct Summarry", 
                 "Select Missing Word",
                 "Highlight Incorrect Words",
                 "Write From Dictation"]
    var image = ["scroll",
                 "fill",
                 "single",
                 "multiple",
                 "correct",
                 "select",
                 "incorrect",
                 "dictation"]
        
    @IBOutlet weak var LisCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.LisCollectionView.dataSource = self
        self.LisCollectionView.delegate = self;
        self.LisCollectionView.register(UINib(nibName: "LisSumSokenCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)//important to recognise label and everything in cell
        self.LisCollectionView!.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 ;    //return number of sections in collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:220)// UICollectionViewDelegateFlowLayout for it work
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LisSumSokenCollectionCell
        
        cell.lblTitle.text = items[indexPath.row]
        
        let cellImage = UIImage(named: self.image[indexPath.row])
        cell.imgSkill.image = cellImage
        return cell;
    }
 
    
}
