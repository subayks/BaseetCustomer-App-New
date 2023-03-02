//
//  HomeCollectionViewDownCell.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class HomeCollectionViewDownCell: UICollectionViewCell {
    
    @IBOutlet weak var timingButton: UIButton!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var hotelLogo: UIImageView!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var offerDesc: UILabel!
    var distanceKms:Float!
    
    var homeCollectionViewDownCellVM: HomeCollectionViewDownCellVM? {
        didSet {
            self.setupValues()
        }
    }
    
    func setupValues() {
        self.bannerImage.layer.cornerRadius = 10
        self.hotelLogo.layer.cornerRadius = 10
        self.timingButton.layer.cornerRadius = 10
        self.bannerImage.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.appcoverlogo ?? "")
        self.hotelLogo.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.applogo ?? "")
        self.timingButton.subtitleLabel?.text = "\(self.homeCollectionViewDownCellVM?.restaurantsModel?.deliveryTime ?? "")  \n Min"
        self.timingButton.subtitleLabel?.textAlignment = .center
        self.salonName.text = self.homeCollectionViewDownCellVM?.restaurantsModel?.name

        self.distanceButton.setTitle("\(String(format: "%.1f", (Float(self.homeCollectionViewDownCellVM?.restaurantsModel?.distance ?? "")!)))K", for: .normal)
        self.ratingButton.setTitle(String(self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0), for: .normal)

//        if (self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0) > 0 {
//            self.ratingButton.isHidden = false
//            self.ratingButton.setTitle(String(self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0), for: .normal)
//        } else {
//            self.ratingButton.isHidden = true
//        }
    }
}


extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
