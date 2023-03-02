//
//  LocationAccessVM.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import Foundation

class LocationAccessVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var navigateToDetailsClosure:(()->())?
    var zoneModel: ZoneModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func changeZoneId() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let lat = UserDefaults.standard.string(forKey: "lat")
            let long = UserDefaults.standard.string(forKey: "long")
            if lat == nil && long == nil{
                self.alertClosure?("Please Enable Location")
                self.hideLoadingIndicatorClosure?()
            }else{
                print("\(Constants.Common.finalURL)/config/get-zone-id?lat=\(lat ?? "")&lng=\(long ?? "")")
                self.apiServices?.getZoneID(finalURL: "\(Constants.Common.finalURL)/config/get-zone-id?lat=\(lat ?? "")&lng=\(long ?? "")",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.zoneModel = result as? ZoneModel
                        UserDefaults.standard.set(self.zoneModel?.zoneId, forKey: "zoneID")
                        self.navigateToDetailsClosure?()
                    } else {
                       self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }
                }
            })
            }
            
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
}
