//
//  NotificationsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificayionL: UILabel!
    @IBOutlet weak var NotificationTB: UITableView!
    var viewModel = NotificationsViewControllerVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificayionL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "notificayionL", comment: "")
        self.viewModel.getNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.NotificationTB.reloadData()
            }
        }
        
        self.viewModel.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.viewModel.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.viewModel.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func notificationBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
}

extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.notificationModel?.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        cell.notificationsTableViewCellVM = self.viewModel.getNotificationsTableViewCellVM(index: indexPath.row)
        return cell
    }
}
