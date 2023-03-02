//
//  HomeCollectionViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 14/07/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    var homeCollectionViewCellVM: HomeCollectionViewCellVM? {
        didSet {
            self.setupValues()
        }
    }
    
    @IBOutlet weak var homeTopimageview: UIImageView!
    
    func setupValues() {
        self.homeTopimageview.layer.cornerRadius = 10
        self.homeTopimageview.loadImageUsingURL(self.homeCollectionViewCellVM?.categoryListModel?.appimage ?? "")
    }
}
