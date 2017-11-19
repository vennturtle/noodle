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
    let regionRadius: CLLocationDistance = 5000  // in meters
    let updateThreshold: CLLocationDistance = 10 // in meters
    let manager = CLLocationManager()
    var selectedAnnotation: MKPointAnnotation!
    
    // when a new location is assigned to this, the map updates automatically
    var lastUpdatedLocation: CLLocation? {
        willSet(newValue) {
            if newValue == nil {
                print("Resetting location updates.")
            }
            else if lastUpdatedLocation == nil {
                print("Initial update at \(newValue!.coordinate)...")
            }
            else {
                print("Updating at new location \(newValue!.coordinate)...")
            }
        }
        
        didSet {
            if let newLocation = self.lastUpdatedLocation {
                // asynchronously retrieves nearby surveys, updates the map once it's done
                Survey.getAll(near: newLocation, radiusInMeters: self.regionRadius, dbref: self.myRef) { surveys in
                    self.currentSurveys = surveys
                    var fuckit = [AnnotationDetails]()
                    let coord = newLocation.coordinate
                    print("These are all within \(self.regionRadius) m of \(coord):")
                    for s in surveys {
                        print("\(s.id!): \(s.title) (\(s.latitude), \(s.longitude))")
                        fuckit += [AnnotationDetails(survey: s)]
                    }
                    DispatchQueue.main.async {
                        self.updateSurveyPins(nowInRange: fuckit)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("MY PRINTS WILL FOLLOW")
        manager.requestWhenInUseAuthorization()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        mapZoom(at: initialPin, radius: regionRadius)
    }
    
    // updates pins on the map
    func updateSurveyPins(nowInRange: [AnnotationDetails]){
        // start with all newly-in-range pins, only add pins not already in map
        var toAdd = Set<AnnotationDetails>(nowInRange)
        print("Found \(nowInRange.count) surveys in range.")
        
        // look through current pins, only collect pins that are no longer in range for deletion
        let toDelete = self.mapView.annotations.filter { old in
            // only delete AnnotationDetails (i.e. not MKUserLocation)
            if let oldAD = old as? AnnotationDetails {
                // only delete if it's not one of the pins that are now in range
                if toAdd.remove(oldAD) == nil { // returns nil if it's not one of the new pins
                    return true
                }
            }
            return false
        }
        
        print("Map already contains \(nowInRange.count - toAdd.count) of these surveys.")
        print("Adding \(toAdd.count) new pins. Removing \(toDelete.count) old pins")
        
        // delete out-of-range pins, add new pins,
        // don't touch the rest of the old pins (or user's current location)
        self.mapView.removeAnnotations(toDelete)
        self.mapView.addAnnotations([AnnotationDetails](toAdd))
    }
    
    // centers the map on the current user location
    func mapZoom(){
        let UserCurrentLocation = (manager.location?.coordinate)!
        let region = MKCoordinateRegionMakeWithDistance(UserCurrentLocation, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    // centers the map on an arbitrary location
    func mapZoom(at: CLLocationCoordinate2D, radius: Double = 5000){
        let region = MKCoordinateRegionMakeWithDistance(at, radius, radius)
        mapView.setRegion(region, animated: true)
    }
    
    /* location manager delegate code */
    
    // location manager delegate function, handles updates of user location
    // only updates nearby surveys if user is far enough away from the last update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
        let lastUpdate = self.lastUpdatedLocation
        let newUpdate = manager.location!
        let shouldUpdate = (lastUpdate == nil || lastUpdate!.distance(from: newUpdate) > self.updateThreshold)
        
        if shouldUpdate {
            print("setting new location to (\(newUpdate.coordinate))")
            self.lastUpdatedLocation = newUpdate
            self.mapZoom(at: newUpdate.coordinate)
        }
    }
    
    // location manager delegate function, handles authorizing location checking
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
    
    /* map view delegate code */
    
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
    
    // customizes the size of the annotation's callout detail, allows word wrap
    func configureDetailView(annotation: AnnotationDetails) -> UIView {
        // initialize label to be used as the callout detail
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
        //label.font = UIFont.systemFont(ofSize: 12)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = annotation.subtitle
        label.numberOfLines = 0     // allow word wrap
        
        // width constraint of detail, maxes out at 250
        let width = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 250)
        label.addConstraint(width)
        
        // height constraint of detail, maxes out at 120
        let height = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 120)
        label.addConstraint(height)
        
        return label
    }
    
    // map view delegate function, handles tapping on a survey pin
    func mapView(_ mapView: MKMapView, didSelect: MKAnnotationView) {
        // when user taps a survey pin, map centers on the pin's location
        if let annoDetails = didSelect.annotation as? AnnotationDetails {
            self.mapZoom(at: annoDetails.coordinate)
        }
    }
    
    // map view delegate function, handles tapping on a callout bubble
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // if the user tapped on the right part of the callout
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? MKPointAnnotation
            performSegue(withIdentifier: "NextView", sender: self)
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destination is TestViewController {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

