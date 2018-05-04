//
//  MapaViewController.swift
//  InCedetec
//
//  Created by Elizabeth Rodríguez Fallas on 21/04/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController:
UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       //Activity indicator
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //termina activity indicator
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000.0
        locationManager.requestWhenInUseAuthorization()
        
        
        mapa.mapType=MKMapType.standard
        let cl=CLLocationCoordinate2DMake(19.283479, -99.135181)
        mapa.region=MKCoordinateRegionMakeWithDistance(cl, 2000, 2000)
        /* //esta es otra forma de definir la región de un mapa
         let origen=CLLocationCoordinate2DMake(0.0, 0.0)
         let delta=CLLocationDegrees(0.01)
         let span=MKCoordinateSpanMake(delta, delta)
         let region=MKCoordinateRegionMake(cl, span)
         mapa.setRegion(region, animated: true)
         */
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mapa.region.center),
                      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mapa.region.span)]
        let placeMark = MKPlacemark(coordinate: cl)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = "CEDETEC"
        mapItem.openInMaps(launchOptions: options)
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = 19.283479
        punto.longitude = -99.135181
        
        
        let pin = MKPointAnnotation()
        pin.coordinate = punto
        pin.title = "CEDETEC"
        pin.subtitle = "ITESM CCM"
        mapa.addAnnotation(pin)
 
        
        mapa.showsCompass=true
        mapa.showsScale=true
        mapa.showsTraffic=true
        mapa.isZoomEnabled=true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView){
         activityIndicator.stopAnimating()
    
    }
    
    
   
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
}
