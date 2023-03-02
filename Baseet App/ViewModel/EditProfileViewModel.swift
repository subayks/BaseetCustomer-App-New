//
//  EditProfileViewModel.swift
//  Baseet App
//
//  Created by Subendran on 23/09/22.
//

import Foundation
import Photos
import UIKit

class EditProfileViewModel {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var replaceUserModel: ReplaceUserModel?
    var allowToPhotos:(()->())?
    var selectedImage:  UIImage? {
        didSet {
            self.uploadProfilePic()
        }
    }
    var setProfileImageClosure:(()->())?

    var customerInfoModel: CustomerInfoModel?

    var firstName = String()
    var lastName = String()
    var emailID = String()
    var password = String()
    
    init(customerInfoModel: CustomerInfoModel, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.customerInfoModel = customerInfoModel
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeUpdateProfileCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let postParam = self.getPostParam()
            self.apiServices?.updateProfileApi(finalURL: "\(Constants.Common.finalURL)/customer/update-profile", withParameters: postParam, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.alertClosure?("Successfully updated!")
                    //self.navigationClosure?()
                } else {
                    self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getPostParam() ->String {
        let jsonToReturn: NSDictionary = ["f_name": "\(self.firstName)", "l_name": "\(self.lastName)","email": "\(self.emailID)"]
    return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func convertDictionaryToJsonString(dict: NSDictionary) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonDataString
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        return nil
    }
    
    func requestPhotoAccess() {
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined || photos == .authorized {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.allowToPhotos?()
                } else {
                    self.alertClosure?("Please enable access for photos from settings")
                }
            })
        } else {
            
            self.alertClosure?("Please enable access for photos from settings")
        }
    }
    
    func validateFields() {

        if self.firstName.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            self.emailID.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
        {
            self.alertClosure?(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please fill up the mandatory fields", comment: ""))
            return
        } else {
            
           if !isValidEmail(testStr: self.emailID) {
                self.alertClosure?("Enter valid Email")
                return
            } else {
                self.makeUpdateProfileCall()
            }
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func uploadProfilePic() {
        let imageRequest = ImageRequestParam(paramName: "image", name: "image", image: self.selectedImage ?? UIImage())
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.uploadProfileApi(finalURL: "\(Constants.Common.finalURL)/customer/update-profile", withParameters: imageRequest, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                       // self.imageModel = result as? ImageModel
                        self.setProfileImageClosure?()
                        self.getCustomerInfo()
                    } else {
                        self.alertClosure?(errorMessage ?? "Some Technical Problem")
                    }
                }
            })
        } else {
            self.alertClosure?("Check your internet")
        }
    }
    
    func getCustomerInfo() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            print("\(Constants.Common.finalURL)/customer/info")
            self.apiServices?.getCustomerInfo(finalURL: "\(Constants.Common.finalURL)/customer/info",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.customerInfoModel = result as? CustomerInfoModel
                    UserDefaults.standard.set(self.customerInfoModel?.fName, forKey: "Name")
                    UserDefaults.standard.set(self.customerInfoModel?.appImage, forKey: "ProfileImage")
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
}
