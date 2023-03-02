//
//  RestaurentCell.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import UIKit

class RestaurentCell: UITableViewCell {

    @IBOutlet weak var timingButton: UIButton!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var hotelLogo: UIImageView!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var offerDesc: UILabel!
    
    var homeCollectionViewDownCellVM: HomeCollectionViewDownCellVM? {
        didSet {
            self.setupValues()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupValues() {
        self.bannerImage.layer.cornerRadius = 10
        self.hotelLogo.layer.cornerRadius = 10
        self.timingButton.layer.cornerRadius = 10
        self.bannerImage.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.appcoverlogo ?? "")
        
        
        if hotelLogo.isEmpty {
            hotelLogo.image = UIImage(named: "logo_watermark")
        }
        else{
            self.hotelLogo.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.applogo ?? "")
            
        }
        
        self.timingButton.subtitleLabel?.text = "\(self.homeCollectionViewDownCellVM?.restaurantsModel?.deliveryTime ?? "")  \n Min"
        self.timingButton.subtitleLabel?.textAlignment = .center
        self.salonName.text = self.homeCollectionViewDownCellVM?.restaurantsModel?.name
        //self.distanceButton.setTitle((self.homeCollectionViewDownCellVM?.restaurantsModel?.distance ?? ""), for: .normal)
        self.distanceButton.titleLabel?.numberOfLines = 1
        self.ratingButton.setTitle(String(self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0), for: .normal)
    }

}

extension UIImageView {
    var isEmpty: Bool { image == nil }
}
