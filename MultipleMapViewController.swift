//
//  MultipleMapViewController.swift
//  GoogleMapPrjct
//
//  Created by Bimal@AppStation on 26/08/22.
//

import UIKit
import MapKit
import GoogleMaps

class MultipleMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        displayMultipleLocationInMapKitView()
        getDirections()
        // Do any additional setup after loading the view.
    }
    func displayMultipleLocationInMapKitView() {
        let locations = [["title": "Trivandrum ", "latitude": 8.5241, "longitude": 76.9366], ["title": "Kochi", "latitude": 9.9312, "longitude": 76.2673], ["title": "Palakkad", "latitude": 10.7867, "longitude": 76.6548], ["title": "Kasaragod", "latitude": 12.4996, "longitude": 74.9869]]
        
//        for location in locations {
//
//            let annotation = MKPointAnnotation()
//            annotation.title = location["title"] as? String
//            let loc = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
//
//            annotation.coordinate =  loc
//            mapView?.addAnnotation(annotation)
//
//        }
        
        for location in locations {
            let info1 = SetCustomPointAnnotation()
            info1.title = location["title"] as? String
            let loc = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            info1.imageName = "pin"
            info1.coordinate =  loc
            mapView?.addAnnotation(info1)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {


        if !(annotation is SetCustomPointAnnotation) {
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

        let cpa = annotation as! SetCustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        let resizedSize = CGSize(width: 30 , height: 30)
        let image = UIImage(named: "pin")
        UIGraphicsBeginImageContext(resizedSize)
        image?.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        anView?.image = resizedImage
        return anView
    }
    
    
    func getDirections() {
           let request = MKDirections.Request()
           // Source
           let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 8.5241, longitude: 76.9366))
           request.source = MKMapItem(placemark: sourcePlaceMark)
           // Destination
           let destPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 12.4996, longitude: 74.9869))
           request.destination = MKMapItem(placemark: destPlaceMark)
           // Transport Types
          request.transportType = [.automobile, .walking]

           let directions = MKDirections(request: request)
           directions.calculate { response, error in
               guard let response = response else {
                   print("Error: \(error?.localizedDescription ?? "No error specified").")
                   return
               }

               let route = response.routes[0]
               self.mapView.addOverlay(route.polyline)

               // …
           }
    }
    
}
extension MultipleMapViewController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Set the color for the line
        renderer.strokeColor = #colorLiteral(red: 0.2405847907, green: 0.5227430377, blue: 1, alpha: 1)
        return renderer
    }
}
class SetCustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

