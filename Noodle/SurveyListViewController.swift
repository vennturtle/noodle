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

class AnnotationDetails: NSObject, MKAnnotation{
    var identifier = "TakeSurvey"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var lat: Double?
    var long: Double?
    var survey: Survey?
    
    init(title: String, subtitle: String, lat:CLLocationDegrees,long:CLLocationDegrees){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        
        super.init()
    }
    
    init(survey: Survey){
        self.survey = survey
        self.title = survey.title
        self.subtitle = "\(survey.desc)\n\nTime left: \(survey.timeRemainingString()!)"
        self.coordinate = CLLocationCoordinate2DMake(survey.latitude, survey.longitude)
    }
}


class SurveyListViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let initialPin = CLLocationCoordinate2DMake(37.3300, -121.8800)
    var myRef = FIRDatabase.database().reference()
    
    var currentSurveys: [Survey] = []
    let regionRadius: CLLocationDistance = 1000 // 1KM ~ 0.621371 miles
    let manager = CLLocationManager()
    var selectedAnnotation: MKPointAnnotation!
    var lastUpdatedLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("MY PRINTS WILL FOLLOW")
        manager.requestWhenInUseAuthorization()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        mapZoom(at: initialPin, radius: 5000)
    }
    
    func retrieveNearbyAndUpdate(){
        self.lastUpdatedLocation = manager.location!
        Survey.getAll(near: (lastUpdatedLocation)!, radiusInKm: regionRadius/1000, dbref: self.myRef) { surveys in
            self.currentSurveys = surveys
            var fuckit = [AnnotationDetails]()
            let coord = self.lastUpdatedLocation!.coordinate
            print("These are all within \(self.regionRadius/1000) km of \(coord):")
            for s in surveys {
                print("\(s.id!): \(s.title) (\(s.latitude), \(s.longitude))")
                //print(currentSurveys)
                fuckit += [AnnotationDetails(survey: s)]
            }
            
            // update pins (only delete old pins out of range, and add new pins)
            let oldPins = self.mapView.annotations
            var toAdd = Set<AnnotationDetails>(fuckit)
            let toDelete = oldPins.filter { old in
                // only delete AnnotationDetails (i.e. not MKUserLocation)
                if let oldAD = old as? AnnotationDetails {
                    // only delete if it's not one of the new pins
                    if toAdd.remove(oldAD) == nil { // returns nil if it's not one of the new pins
                        return true
                    }
                }
                return false
            }
            // delete out-of-range pins, add new pins,
            // don't touch the rest of the old pins (or user's current location)
            self.mapView.removeAnnotations(toDelete)
            self.mapView.addAnnotations([AnnotationDetails](toAdd))
            self.mapZoom(at: self.manager.location?.coordinate ?? self.initialPin)
        }
    }
    
    func mapZoom(){
        let UserCurrentLocation = (manager.location?.coordinate)!
        let region = MKCoordinateRegionMakeWithDistance(UserCurrentLocation, 5000, 5000)
        mapView.setRegion(region, animated: true)
    }
    
    func mapZoom(at: CLLocationCoordinate2D, radius: Double = 5000){
        let region = MKCoordinateRegionMakeWithDistance(at, radius, radius)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
        if lastUpdatedLocation == nil || lastUpdatedLocation!.distance(from: manager.location!) > 10 {
            retrieveNearbyAndUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied){
            showLocationIsAblePopUp()
        }
    }
    
    //Create a Alert pop up that sends user to settings if they do not allow
    func showLocationIsAblePopUp(){
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
            } else {
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
                view.isEnabled = true
                view.canShowCallout = true
                view.detailCalloutAccessoryView = self.configureDetailView(annotation: annotation)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect: MKAnnotationView) {
        //self.selectedAnnotation = view.annotation as? MKPointAnnotation
        if let annoDetails = didSelect.annotation as? AnnotationDetails {
            self.mapZoom(at: annoDetails.coordinate)
        }

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? MKPointAnnotation
            performSegue(withIdentifier: "NextView", sender: self)
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destination is TestViewController {
        }
    }
    
    func configureDetailView(annotation: AnnotationDetails) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
        label.text = annotation.subtitle
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        
        let width = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 250)
        label.addConstraint(width)
        
        let height = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 120)
        label.addConstraint(height)
        
        return label
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

