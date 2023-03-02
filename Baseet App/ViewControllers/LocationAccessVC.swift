//
//  LocationAccessVC.swift
//  Baseet App
//
//  Created by VinodKatta on 22/07/22.
//

import UIKit
import CoreLocation
import MapKit

class LocationAccessVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var searchLocation: UISearchBar!
    @IBOutlet weak var mainAreaLbl: UILabel!
    @IBOutlet weak var localArea: UILabel!
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    @IBOutlet weak var selectLocationLbl: UILabel!
    @IBOutlet weak var selectDeliveryLocation: UILabel!
    
    @IBOutlet weak var confirmLocationLbtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let locationAccessVM = LocationAccessVM()
    var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchLocation.delegate = self
        selectLocationLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select Location", comment: "")
        selectDeliveryLocation.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "SELECT DELIVERY LOCATION", comment: "")
        confirmLocationLbtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CONFIRM LOCATION", comment: ""), for: .normal)
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true

            if let coor = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coor, animated: true)
            }
        
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.showLoadingIndicatorClosure?()
        searchBar.resignFirstResponder()
        dismiss(animated: true)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start{ [self] (response,error) in
            self.hideLoadingIndicatorClosure?()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("Error")
            }else{
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotation(annotations as! MKPointAnnotation)
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                UserDefaults.standard.set(latitude, forKey: "lat")
                UserDefaults.standard.set(longitude, forKey: "long")
                let Annotation = MKPointAnnotation()
                Annotation.title = searchBar.text
                Annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(Annotation)
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                self.getAddressFromLatLon(pdblLatitude: latitude!, withLongitude: longitude!)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        mapView.addAnnotation(annotation)
        let userLocation :CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        //Launch App first Time
        if UserDefaults.standard.string(forKey: "User_Id") == nil {
        UserDefaults.standard.set((Int(String(userLocation.coordinate.latitude).replacingOccurrences(of: ".", with: ""))), forKey: "User_Id")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }

        
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
                self.mainAreaLbl.text = (pm!.locality ?? "")
                self.localArea.text = "\(String(describing: pm!.administrativeArea ?? "")),\(pm!.country ?? "")\(pm!.subLocality ?? "") \(pm!.postalCode ?? "")"
                UserDefaults.standard.set(locationDashBord, forKey: "Location_Info")
                UserDefaults.standard.set((pm!.locality!), forKey: "City_Name")
            }
        
            })
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

                        self.localArea.text = addressString
                        print(addressString)
                  }
            })

        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationAccessVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.locationAccessVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.locationAccessVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.locationAccessVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "tabVC")
                vc.modalPresentationStyle = .fullScreen
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            print("restricted App")
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            print("denied location")
            break
        default:
            break
        }
    }
   
    
    @IBAction func locationConfirmBtn(_ sender: Any) {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "LoginViewController")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.locationAccessVM.changeZoneId()
       
    }
}
