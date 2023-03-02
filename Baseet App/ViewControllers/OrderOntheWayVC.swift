//
//  OrderOntheWayVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit
import Alamofire


class OrderOntheWayVC: UIViewController {
    
    @IBOutlet weak var expectedDeliveryTime: UILabel!
    var seconds = 60
    @IBOutlet weak var timeLeftLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var orderTB: UITableView!
    var orderOntheWayVM: OrderOntheWayVM?
    var rowHeight:CGFloat = 0.0
    @IBOutlet weak var cancelOrderBtn: UIButton!{
        didSet{
            self.cancelOrderBtn.layer.cornerRadius = 5.0
            self.cancelOrderBtn.layer.masksToBounds = true
        }
    }
    
    var timer: Timer?
    var totalTime = 60
    var orderPlacedScreen:String!
    var timerLimit:Timer?
   
    override func viewDidLoad(){
        super.viewDidLoad()
       
        if selectedIndexValues == "0"{
            orderStatusLbl.isHidden = true
            let orderID = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OrderID", comment: "")
            self.orderID.text = "\(orderID) \(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)"
        }
        if selectedIndexValues == "1"{
            orderStatusLbl.isHidden = false
            let orderID = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OrderID", comment: "")
            self.orderID.text = "\(orderID) \(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)"
            print(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)
            self.orderStatusLbl.text = "Order Status \(self.orderOntheWayVM?.orderTrackModel?.orderStatus ?? "")"
        }
        if orderPlacedScreen == "CancelNow"{
            orderStatusLbl.isHidden = true
            let orderID = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OrderID", comment: "")
            self.orderID.text = "\(orderID) \(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)"
        }
        self.expectedDeliveryTime.text = "Expected Delivery Time: \(self.orderOntheWayVM?.orderTrackModel?.totalTime ?? "")"
        
        self.setupNavigationBar()
        self.orderOntheWayVM?.setupOrderInfo()
        orderTB.register(UINib(nibName: "OrderTrackFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "OrderTrackFooterView")
//        let orderID = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OrderID", comment: "")
//        self.orderID.text = "\(orderID) \(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)"
        if orderPlacedScreen == "CancelNow"{
            self.timeLeftLbl.isHidden = false
            self.cancelOrderBtn.isHidden = false
            self.cancelOrderBtn.addTarget(self, action: #selector(cancelItems), for: .touchUpInside)
        }else{
            cancelOrderBtn.isHidden = true
            timeLeftLbl.isHidden = true
        }
        //timerLimit = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(TimerValidate), userInfo: nil, repeats: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timerLimit in
            self.seconds -= 1
            if self.seconds == 0 {
                print("Go!")
                timerLimit.invalidate()
                self.cancelOrderBtn.isHidden = true
                self.timeLeftLbl.isHidden = true
            } else {
                print(self.seconds)
                self.timeLeftLbl.text = "Time Left: \(self.seconds) Seconds"
            }
        }
    }
    
    @objc func TimerValidate(){
        timerLimit?.invalidate()
        cancelOrderBtn.isHidden = true
        timeLeftLbl.isHidden = true
    }
    
    @objc func cancelItems(){
        var refreshAlert = UIAlertController(title: "", message: "Are You Sure You Want To Cancel The Order", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.CancelOrders()
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          
          })) 

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func CancelOrders(){
        if Reachability.isConnectedToNetwork(){
            showLoadingView()
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)"
            ]
            print(headers)
            let parameters = [
                "order_id": (self.orderOntheWayVM?.orderTrackModel?.id ?? 0)
                ]
            print(parameters)
            AF.request("\(Constants.Common.finalURL)/customer/order/cancel", method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            let response = json as! NSDictionary
                            print(response)
                            guard let message = response["message"] as? String else{
                                hideLoadingView()
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Not found", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(identifier: "tabVC")
                                    vc.modalTransitionStyle = .coverVertical
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            
                            if message == "Order canceled successfully!"{
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(identifier: "tabVC")
                                    vc.modalTransitionStyle = .coverVertical
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }else{
                                hideLoadingView()
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.orderOntheWayVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.orderOntheWayVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.orderOntheWayVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.orderOntheWayVM?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.orderTB.reloadData()
            }
        }
        
        self.orderOntheWayVM?.successClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.navigateToSuccessView()
            }
        }
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
    }
    
    @IBAction func orderBackBtn(_ sender: Any) {
        if self.orderOntheWayVM?.isFromSuccessScreen == true {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "tabVC")
            vc.modalPresentationStyle = .fullScreen
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        } else {
            self.dismiss(animated: true,completion: nil)
        }
    }
    
    @IBAction func trackOrderBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapkitViewVC") as! MapkitViewVC
        vc.modalPresentationStyle = .fullScreen
        vc.mapkitViewVM = self.orderOntheWayVM?.getMapkitViewVM()
        self.present(vc, animated: true, completion: nil)
    }
    
    func navigateToSuccessView() {
        if self.orderOntheWayVM?.isFromSuccessScreen == true {
            let delay : Double = 5.0    // 5 seconds here
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "DeliveredSucessViewVC") as! DeliveredSucessViewVC
                vc.deliveredSucessViewVM = self.orderOntheWayVM?.getDeliveredSucessViewVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
}

extension OrderOntheWayVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil {
            return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.orderOntheWayVM?.orderInfoArray.count ?? 0
        } else if section == 1 {
            if self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil {
                return self.orderOntheWayVM?.orderTrackModel?.details?.count ?? 0
            }
            return 1
        } else {
            return self.orderOntheWayVM?.orderTrackModel?.details?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2 ||  self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order Details", comment: "")
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderOnTableViewCell
            cell.orderStatus.setTitle(self.orderOntheWayVM?.orderInfoArray[indexPath.row].title, for: .normal)
            cell.orderStatus.setImage(UIImage(named: self.orderOntheWayVM?.orderInfoArray[indexPath.row].image ?? ""), for: .normal)
            if self.orderOntheWayVM?.orderInfoArray[indexPath.row].isSelected == true {
                cell.orderStatus.backgroundColor = .red
            } else {
                cell.orderStatus.backgroundColor = .gray
            }
            cell.orderStatus.layer.cornerRadius = 10
            
            return cell
        } else if  indexPath.section == 1 {
            if self.orderOntheWayVM?.orderTrackModel?.deliveryMan != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailsCell", for: indexPath) as! DeliveryDetailsCell
                cell.deliveryDetailsCellVM = self.orderOntheWayVM?.getDeliveryManViewModel()
                if selectedIndexValues == "0"{
                    cell.deliveryPersonDetailsLbl.text = "Delivery Personal Details"
                    cell.phoneNumber.isHidden = false
                }
                if selectedIndexValues == "1"{
                    cell.deliveryPersonDetailsLbl.text = "Order Status"
                    cell.nameLabel.text = "Delivered Date/Time."
                    cell.phoneNumber.isHidden = true
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsListCell", for: indexPath) as! OrderItemsListCell
                cell.OrderItemsListCellVM = self.orderOntheWayVM?.getOrderItemsListCellVM(index: indexPath.row)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsListCell", for: indexPath) as! OrderItemsListCell
            
            cell.OrderItemsListCellVM = self.orderOntheWayVM?.getOrderItemsListCellVM(index: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == 2 ||  self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0  {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderTrackFooterView") as! OrderTrackFooterView
            headerView.totalChargeValue.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.orderAmount ?? 0)"
            headerView.couponCost.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.restaurantDiscountAmount ?? 0)"
            headerView.deliveryCost.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.deliveryCharge ?? 0)"
            headerView.overView.layer.cornerRadius = 5
            headerView.totalChargeOverView.layer.cornerRadius = 5
            headerView.deliveryCharge.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery Charge", comment: "")
            headerView.couponCode.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Coupon", comment: "")
            headerView.totalCharge.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Total Charge", comment: "")
            return headerView
        }
        else{

        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 2 || self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return 30
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 2 || self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return 157
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        if selectedIndexValues == "0"{
            return UITableView.automaticDimension
        }else{
            if indexPath.section == 0{
                return 0
            }else{
                return UITableView.automaticDimension
            }
            return 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((orderTB.contentOffset.y + orderTB.frame.size.height) >= orderTB.contentSize.height)
        {
            DispatchQueue.main.async {
                self.orderOntheWayVM?.getOrderTrack()
            }
        }
    }
}
