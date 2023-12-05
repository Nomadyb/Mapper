//
//  ViewController.swift
//  TravelBook
//
//  Created by Ahmet Emin Yalçınkaya on 4.12.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate {
	
	
	
	
	@IBOutlet weak var mapView: MKMapView!
	
	@IBOutlet weak var nameText: UITextField!
	
	@IBOutlet weak var commentText: UITextField!
	
	
	
	//user locations
	var locationManager = CLLocationManager()
	var chosenLongitude = Double()
	var chosenLatitude = Double()
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		mapView.delegate = self
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest//en iyi konum bulma
		locationManager.requestWhenInUseAuthorization()//uygulamayı kullanırken
		locationManager.startUpdatingLocation()
		
		
		
		let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
		
		gestureRecognizer.minimumPressDuration = 2
		mapView.addGestureRecognizer(gestureRecognizer)
		
		
		
		
	}
	
	
	@objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer) {
		
		if gestureRecognizer.state == .began  {
			let touchedPoint = gestureRecognizer.location(in:  self.mapView)
			let touchCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
			
			chosenLatitude = touchCoordinates.latitude
			chosenLongitude = touchCoordinates.longitude
			
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = touchCoordinates
			annotation.title =  nameText.text
			annotation.subtitle = commentText.text
			self.mapView.addAnnotation(annotation)
			
		}
		
		
		
		
		
	}
	
	
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true )
		
		
		
	}
	
	
	
	
	
	@IBAction func saveButtonClicked(_ sender: Any) {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let context = appDelegate.persistentContainer.viewContext
		
		let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
		
		newPlace.setValue(nameText.text, forKey: "title")
		newPlace.setValue(commentText.text, forKey: "subtitle")
		newPlace.setValue(chosenLatitude, forKey: "latitude")
		newPlace.setValue(chosenLongitude,forKey: "longitude")
		newPlace.setValue(UUID(), forKey: "id")
		
		do{
			try context.save()
			print("succes")
		} catch {
			print("error")
			
			
		}
		
		
		
		
	}
	


}

