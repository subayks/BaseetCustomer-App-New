//
//  DeliveryDetailsCell.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import UIKit

class DeliveryDetailsCell: UITableViewCell {

    @IBOutlet weak var deliveryPersonDetailsLbl: UILabel!{
        didSet{
            deliveryPersonDetailsLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery Person Details", comment: "")
        }
    }
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var deliveryDetailsCellVM: DeliveryDetailsCellVM? {
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
        self.phoneNumber.text = self.deliveryDetailsCellVM?.deliveryManModel?.phone
        self.nameLabel.text = self.deliveryDetailsCellVM?.deliveryManModel?.fName
        self.dateTime.text = "\(self.formattedTimeString(date: self.deliveryDetailsCellVM?.deliveryTime ?? "")),  \((self.formattedDateString(date: self.deliveryDetailsCellVM?.deliveryTime ?? "")))"
        //self.dateTime.text = "\(self.formattedDateString(date: (self.deliveryDetailsCellVM?.deliveryTime)!))"
    }
    
    func formattedTimeString(date: String) ->String
    {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString) ?? Date()

        dateFormatter.dateFormat = "h:mm a"
        return (dateFormatter.string(from: dateObj))
    }
    
    func formattedDateString(date: String) ->String
    {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString)  ?? Date()

        dateFormatter.dateFormat = "dd/mm/YY"
        return (dateFormatter.string(from: dateObj))
    }

}
