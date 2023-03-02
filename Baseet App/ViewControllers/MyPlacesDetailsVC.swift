//
//  MyPlacesDetailsVC.swift
//  Baseet App
//
//  Created by APPLE on 14/11/22.
//

import UIKit
import MapKit
import CoreLocation

class MyPlacesDetailsVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate  {
    
    @IBOutlet weak var mapVieww: MKMapView!
    var locationManager: CLLocationManager!
    var latitude:String!
    var longtitude:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    

    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
            CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
        }
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
