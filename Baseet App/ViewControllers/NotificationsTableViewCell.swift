//
//  NotificationsTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var labelDiscription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var notificationsTableViewCellVM: NotificationsTableViewCellVM? {
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
        self.dateLabel.text = self.formattedDateString(date: self.notificationsTableViewCellVM?.notificationModel?.createdAt ?? "")
        self.labelDiscription.text = self.notificationsTableViewCellVM?.notificationModel?.data?.description ?? ""
        self.labelTitle.text = self.notificationsTableViewCellVM?.notificationModel?.data?.title ?? ""
    }
    
    func formattedDateString(date: String) ->String{
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString)  ?? Date()
        dateFormatter.dateFormat = "dd MMM"
        return (dateFormatter.string(from: dateObj))
    }

}
