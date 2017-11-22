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

class SurveyAnnotation: NSObject, MKAnnotation {
    var identifier = "TakeSurvey"
    var survey: Survey
    
    var title: String? {
        return survey.title
    }
    var subtitle: String? {
        guard let remaining = survey.timeRemainingString() else { return nil }
        return "\(survey.desc)\n\nTime left: \(remaining)"
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(survey.latitude, survey.longitude)
    }
    
    init(_ survey: Survey){
        self.survey = survey
        super.init()
    }
    
    func getSurvey() -> Survey {
        return self.survey
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
    var chosenAnnotation: SurveyAnnotation?
    

    
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
                    if let userID = FIRAuth.auth()?.currentUser?.uid {
                        self.currentSurveys = surveys.filter { $0.uid! != userID }
                    }
                    var fuckit = [SurveyAnnotation]()
                    let coord = newLocation.coordinate
                    print("These are all within \(self.regionRadius) m of \(coord):")
                    for s in self.currentSurveys {
                        print("\(s.id!): \(s.title) (\(s.latitude), \(s.longitude))")
                        fuckit += [SurveyAnnotation(s)]
                    }
                    DispatchQueue.main.async {
                        let toDelete = self.mapView.annotations.filter { $0 is SurveyAnnotation }
                        self.mapView.removeAnnotations(toDelete)
                        self.mapView.addAnnotations(fuckit)
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
    
    // centers the map on the current user location
    func mapZoom(){
        let UserCurrentLocation = (manager.location?.coordinate)!
        let region = MKCoordinateRegionMakeWithDistance(UserCurrentLocation, 2*regionRadius, 2*regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    // centers the map on an arbitrary location
    func mapZoom(at: CLLocationCoordinate2D, radius: Double = 5000){
        let region = MKCoordinateRegionMakeWithDistance(at, 2*radius, 2*radius)
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
        if let annotation = annotation as? SurveyAnnotation{
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
    func configureDetailView(annotation: SurveyAnnotation) -> UIView {
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
        if let annoDetails = didSelect.annotation as? SurveyAnnotation {
            self.mapZoom(at: annoDetails.coordinate)
        }
    }
    
    // map view delegate function, handles tapping on a callout bubble
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // if the user tapped on the right part of the callout
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? MKPointAnnotation
            chosenAnnotation = view.annotation as? SurveyAnnotation
//            print(chosenAnnotation?.getSurvey().title)
            performSegue(withIdentifier: "NextView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("going here?")
        if segue.identifier == "NextView" {
            let navigationController = segue.destination as! UINavigationController
            let takeSurveyViewController = navigationController.topViewController as! TakeSurveyViewController
//            print("Chosen annotation: \(chosenAnnotation?.getSurvey().title)")
            takeSurveyViewController.currentSurvey = chosenAnnotation?.getSurvey()
    }
    
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

