//
//  MapkitViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 26/07/22.
//

import UIKit
import MapKit

class MapkitViewVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var mapkitViewVM: MapkitViewVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationSetup()
        _ = Timer.scheduledTimer(timeInterval: 5.0,
                                    target: self,
                                    selector: #selector(execute),
                                    userInfo: nil,
                                    repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapkitViewVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.mapkitViewVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.mapkitViewVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.mapkitViewVM?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.locationSetup()
            }
        }
    }
    
    @objc func execute() {
        self.mapkitViewVM?.getOrderTrack()
    }
    
    func locationSetup() {
        let customerLat = Double(self.mapkitViewVM?.orderTrackModel?.deliveryAddress?.latitude ?? "") ?? 0.0
        let customerLong = Double(self.mapkitViewVM?.orderTrackModel?.deliveryAddress?.longitude ?? "") ?? 0.0
        let deliveryManLat = Double(self.mapkitViewVM?.orderTrackModel?.deliveryMan?.lat ?? "") ?? 0.0
        let deliveryLong = Double(self.mapkitViewVM?.orderTrackModel?.deliveryMan?.lng ?? "") ?? 0.0
      
        
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
       //long 78.4867
       // lat 17.3850
        let sourceLocation = CLLocationCoordinate2D(latitude: deliveryManLat, longitude: deliveryLong)
        let destinationLocation = CLLocationCoordinate2D(latitude: customerLat, longitude: customerLong)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = CustomPointAnnotation()
        sourceAnnotation.title = "Info2"
        sourceAnnotation.subtitle = "Subtitle"
        sourceAnnotation.imageName = "Delivery_Mini"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

               if !(annotation is CustomPointAnnotation) {
                   return nil
               }

               let reuseId = "test"

        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
               if anView == nil {
                   anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                   anView?.canShowCallout = true
               }
               else {
                   anView?.annotation = annotation
               }

               //Set annotation-specific properties **AFTER**
               //the view is dequeued or created...

        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)

               return anView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func DoneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
