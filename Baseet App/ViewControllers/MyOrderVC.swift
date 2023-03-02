//
//  MyOrderVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit
import Alamofire

var selectedIndexValues: String!

class MyOrderVC: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var myCurrentOrderTB: UITableView!
    var selectedIndex = 0
   
    var myOrderVM = MyOrderVM()
    
    @IBOutlet weak var myOrderL: UILabel!
    @IBOutlet weak var segmentL: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myOrderL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "My Orders", comment: "")
        self.segmentL.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Current Orders", comment: ""), forSegmentAt: 0)
        self.segmentL.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Past Order", comment: ""), forSegmentAt: 1)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        self.setupNavigationBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
        selectedIndexValues = "0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.myOrderVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.myOrderVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.myOrderVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.myOrderVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.myCurrentOrderTB.reloadData()
            }
        }
        
        self.myOrderVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                vc.orderOntheWayVM = self.myOrderVM.getOrderOntheWayVM()
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if selectedIndexValues == "0"{
            self.myOrderVM.makeOrderListCall(type: 0, limitAdded: 0)
        }else{
            self.myOrderVM.makeOrderListCall(type: 1, limitAdded: 0)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func myOderSeqment(_ sender: Any) {
        self.myOrderVM.ordersListModel?.orders?.removeAll()
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.selectedIndex = 0
            selectedIndexValues = "0"
            if selectedIndexValues == "0"{
                self.myOrderVM.makeOrderListCall(type: 0, limitAdded: 0)
            }
            
        }
        else if (sender as AnyObject).selectedSegmentIndex == 1 {
            self.selectedIndex = 1
            selectedIndexValues = "1"
            if selectedIndexValues == "1"{
                self.myOrderVM.makeOrderListCall(type: 1, limitAdded: 0)
            }
           
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionModify(_ sender: Any) {
    }
    
    @IBAction func orderDetails(_ sender: UIButton) {
        self.myOrderVM.getOrderTrack(index: sender.tag)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
}
extension MyOrderVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrderVM.ordersListModel?.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCurrentOrderTableViewCell
            cell.modifyOrderBtn.tag = indexPath.row
            cell.orderDetailsBtn.tag = indexPath.row
            cell.modifyOrderBtn.layer.cornerRadius = 10
            cell.orderDetailsBtn.layer.cornerRadius = 10
            cell.myCurrentOrderTableViewCellVM = self.myOrderVM.getMyCurrentOrderTableViewCellVM(index: indexPath.row, type: selectedIndex)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPastOrderTableViewCell", for: indexPath) as! MyPastOrderTableViewCell
            cell.orderDetailsBtn.tag = indexPath.row
            cell.orderDetailsBtn.layer.cornerRadius = 10
            
           // cell.orderDetailsBtn.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            
            cell.myPastOrderTableViewCellVM = self.myOrderVM.getMyPostOrderTableViewCellVM(index: indexPath.row, type: selectedIndex)

            return cell
        }
        
        
    }
    
    
  /*  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if selectedIndex == 0{
            let add = UIContextualAction(style: .normal, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel Orders", comment: "")) { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void) in
                    
                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Are you sure you want to delete the Current Orders", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "No", comment: ""), style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
                }))

                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Yes", comment: ""), style: .destructive, handler: { (alertAction) in
                    self.myOrderVM.getOrderID(index: indexPath.row)
                    print(UserDefaults.standard.string(forKey: "OrderID"))
                    self.cancelOrders()
                }))
                        
                self.present(alert, animated: true)
                
            }
            return UISwipeActionsConfiguration(actions: [add])
        }
       
       return UISwipeActionsConfiguration()
        
    }*/
    
    func cancelOrders(){
        if Reachability.isConnectedToNetwork(){
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)"
            ]
            print(headers)
            let parameters = [
                "order": (UserDefaults.standard.string(forKey: "OrderID")!)
                ]
            print(parameters)
            AF.request("\(Constants.Common.finalURL)customer/order/cancel", method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            let response = json as! NSDictionary
                            print(response)
                            guard let message = response["message"] as? String else{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Not found", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            if message == "Successfully removed!"{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        case .failure(let error):
                            print(error)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                }
        }else{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
//    @objc func connected(sender: UIButton){
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "PastOrderDetailsVC") as! PastOrderDetailsVC
//        vc.modalPresentationStyle = .fullScreen
//        self.myOrderVM.getOrderTrack(index: sender.tag)
//        self.present(vc, animated: true, completion: nil)
//    }
    
    @objc func orderDetailsAction() {
        print("no")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myOrderVM.getOrderTrack(index: indexPath.row)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((myCurrentOrderTB.contentOffset.y + myCurrentOrderTB.frame.size.height) >= myCurrentOrderTB.contentSize.height)
        {
            DispatchQueue.main.async {
                self.myOrderVM.makeOrderListCall(type: self.selectedIndex, limitAdded: 10)
            }
        }
    }
}

//Textfield delegates
extension MyOrderVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        query = searchBar.text ?? ""
//        self.searchRestaurentVM.getSearchItem(query: searchBar.text ?? "")
        self.searchField.endEditing(true)
    }
}


