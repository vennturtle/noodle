//
//  SurveyListViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

var currentSurveys: [Survey] = []
var surveyUpdateHandle: FIRDatabaseHandle?
var surveyUpdateQuery: FIRDatabaseQuery?


class AnnotationDetails: NSObject, MKAnnotation{
    var identifier = "TakeSurvey"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var lat: Double?
    var long: Double?
    
    
    init(title: String, subtitle: String, lat:CLLocationDegrees,long:CLLocationDegrees){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        
        super.init()
    }
    
}

class PinLocation: NSObject {
    //I think here is where I should load the surveys??
    var surveyPin = [AnnotationDetails]()
    override init(){
        surveyPin += [AnnotationDetails(title:"THis is the Title",subtitle: "this is a long description to test what it would look like", lat:37.3352,long:-121.8811  )]
        surveyPin += [AnnotationDetails(title:"SRVY2",subtitle: "desc",lat:37.337666,long: -121.885907 )]
        surveyPin += [AnnotationDetails(title:"SRVY3",subtitle: "desc",lat:37.3382,long: -121.8812 )]
    }
}

class SurveyListViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let initialPin = CLLocationCoordinate2DMake(37.3300, -121.8800)
    let surveys = PinLocation().surveyPin
    var myRef = FIRDatabase.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("MY PRINTS WILL FOLLOW")
        manager.requestWhenInUseAuthorization()

        Survey.getAll(near: (manager.location)!, radiusInKm: regionRadius, dbref: self.myRef) { surveys in
            print("These are all within \(self.regionRadius) km of campus:")
            for s in surveys {
                print("\(s.id!): \(s.title) (\(s.latitude), \(s.longitude))")
                print(currentSurveys)
                var fuckit = [AnnotationDetails]()
                fuckit += [AnnotationDetails(title: s.title,subtitle: s.desc,lat:s.latitude,long: s.longitude )]
                self.mapView.addAnnotations(fuckit)

            
            }


        }

        
        mapZoom()
       // mapView.addAnnotations(surveys)
        mapView.delegate = self
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
                   }
    private let regionRadius:CLLocationDistance = 1000 // 1KM ~ 0.621371 miles
    func mapZoom(){
        let region = MKCoordinateRegionMakeWithDistance(initialPin, 5000, 5000)
        mapView.setRegion(region, animated: true)
    }
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
    }
    //
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied){
            showLocationisablePopUp()
        }
    }
    //Create a Alert pop up that sends user to settings if they do not allow
    func showLocationisablePopUp(){
        let alertController = UIAlertController(title: "Location Access Disabled", message: "In order for us to match you with surveys, we will need access to your location", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default){(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    //make changes ot the annotation

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AnnotationDetails{
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView {
                return view
            }else{
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
                view.isEnabled = true
                view.canShowCallout = true
//                view.detailCalloutAccessoryView = self.configureDetailView(annotationView: view)
                view.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                
                
                
                
                return view
            }
        }
        return nil
    }
    
    var selectedAnnotation: MKPointAnnotation!
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            selectedAnnotation = view.annotation as? MKPointAnnotation
            performSegue(withIdentifier: "NextView", sender: self)
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destination is TestViewController {
        }
    }
//    func configureDetailView(annotationView: MKAnnotationView) -> UIView {
//        let snapshotView = UIView()
//        let views = ["snapshotView": snapshotView]
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(200)]", options: [], metrics: nil, views: views))
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(75)]", options: [], metrics: nil, views: views))
//        
//        //do your work
//        
//        return snapshotView
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}

