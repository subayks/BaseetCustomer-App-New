//
//  ChangeLocationViewController.swift
//  Baseet App
//
//  Created by APPLE on 15/11/22.
//

import UIKit
import MapKit
import Alamofire

class ChangeLocationViewController: UIViewController,MKMapViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var deliveryLocationLbl: UILabel!{
        didSet{
            deliveryLocationLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select Delivery Location", comment: "")
        }
    }
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapVieww: MKMapView!
    
    var showLoadingIndicatorClosure:(()->())?
    
    var hideLoadingIndicatorClosure:(()->())?
    
    var apiServices: HomeApiServicesProtocol?
    
    var latitude : Double!
    var longitude : Double!
    var isSearched:String!
    
    @IBOutlet weak var changelocBtn: UIButton!{
        didSet{
            changelocBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change Location", comment: ""), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapVieww.delegate = self
        mapVieww.mapType = .standard
        mapVieww.isZoomEnabled = true
        mapVieww.isScrollEnabled = true
        self.hideKeyboardWhenTappedAround()
        if let coor = mapVieww.userLocation.location?.coordinate{
            mapVieww.setCenter(coor, animated: true)
        }
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

        mapVieww.delegate = self
        mapVieww.mapType = .standard
        mapVieww.isZoomEnabled = true
        mapVieww.isScrollEnabled = true

            if let coor = mapVieww.userLocation.location?.coordinate{
                mapVieww.setCenter(coor, animated: true)
            }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isSearched == "searchingLocation"{
            print("Fetching search Location")
        }else{
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            mapVieww.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapVieww.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            let userLocation :CLLocation = locations[0] as CLLocation
            annotation.title = "You are Here"
            annotation.subtitle = ""
            mapVieww.addAnnotation(annotation)

            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
                    print(userLocation)
                    guard error == nil else {
                        print("Reverse geocoder failed with error")
                        return
                    }
                guard placemarks!.count > 0 else {
                        print("Problem with the data received from geocoder")
                        return
                    }
                let pm = placemarks?[0]
                if pm == nil{
                    self.showToast(message: "Location Not Updated", font: .systemFont(ofSize: 16))
                }else{
                    let locationDashBord = "\(pm!.locality ?? ""), \(pm!.subLocality ?? ""),\(pm!.administrativeArea ?? "") \(pm!.country!),\(pm!.postalCode ?? "")"
                   print(locationDashBord)
                    self.addressLbl.text = (pm!.locality ?? "")
                    self.addressLbl.text = "\(String(describing: pm!.administrativeArea ?? "")),\(pm!.country ?? "")\(pm!.subLocality ?? "") \(pm!.postalCode ?? "")"
                   // UserDefaults.standard.set(locationDashBord, forKey: "Location_Info")
                   // UserDefaults.standard.set((pm!.locality!), forKey: "City_Name")
                }
            
                })
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearched = "searchingLocation"
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.showLoadingIndicatorClosure?()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start{ [self] (response,error) in
            self.hideLoadingIndicatorClosure?()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("Error")
            }else{
//                let annotations = self.mapView.annotations
//                self.mapView.removeAnnotation(annotations as! MKPointAnnotation)
                latitude = response?.boundingRegion.center.latitude
                longitude = response?.boundingRegion.center.longitude
                UserDefaults.standard.set(latitude, forKey: "lat")
                UserDefaults.standard.set(longitude, forKey: "long")
                let Annotation = MKPointAnnotation()
                Annotation.title = searchBar.text
                Annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapVieww.addAnnotation(Annotation)
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapVieww.setRegion(region, animated: true)
                self.getAddressFromLatLon(pdblLatitude: latitude!, withLongitude: longitude!)
            }
            
        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("hi")
    }
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                        self.addressLbl.text = addressString
                        print(addressString)
                  }
            })

        }


    @IBAction func changelocationBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MyplacesFormDetailsViewController") as! MyplacesFormDetailsViewController
        vc.modalTransitionStyle = .coverVertical
        vc.addressText = self.addressLbl.text!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
     /*   if latitude == nil{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location Is Not Updated", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if longitude == nil{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location Is Not Updated", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            if Reachability.isConnectedToNetwork(){
                let token = UserDefaults.standard.string(forKey: "AuthToken")
                let headers : HTTPHeaders = [
                    "Authorization": " \(token!)"
                ]
                print(headers)
                let parameters = [
                    "address": "\(self.addressLbl.text!)",
                    "latitude": "\(self.latitude!)",
                    "longitude": "\(self.longitude!)"
                    ]
                print(parameters)
                AF.request("\(Constants.Common.finalURL)/customer/address/add", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { [self] response in
                            switch response.result {
                            case .success(let json):
                                let response = json as! NSDictionary
                                print(response)
                                 let message = response["message"] as? String
                                    print(message)
                                if message == "Successfully added!"{
                                    let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: message!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                        let storyboard = UIStoryboard.init(name: "MyPlacesStoryboard", bundle: nil)
                                        let vc = storyboard.instantiateViewController(identifier: "MyplacesFormDetailsViewController") as! MyplacesFormDetailsViewController
                                        vc.modalTransitionStyle = .coverVertical
                                        vc.addressText = self.addressLbl.text!
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
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

        }*/
       
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangeLocationViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    

}

