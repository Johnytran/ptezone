//
//  File.swift
//  PTEzone
//
//  Created by Tuan Anh on 14/3/2024.
//

import UIKit

class LisSumSpoken: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LisSumSokenCollectionCell
    
        
        return cell
    }
    
    
}
