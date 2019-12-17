//
//  MapViewController+Extension.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import SystemConfiguration


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Save the region everytime we change the map
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(self.mapView.region.center.latitude, forKey: latitudeS)
        defaults.set(self.mapView.region.center.longitude, forKey: longitudeS)
        defaults.set(self.mapView.region.span.latitudeDelta, forKey: deltaLatitude)
        defaults.set(self.mapView.region.span.longitudeDelta, forKey: deltaLongitude)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        checkReachable()
        let coordinate = view.annotation?.coordinate
        if (onEdit) {
            
            for location in locations {
                if location.lat == (coordinate!.latitude) && location.long == (coordinate!.longitude) {
                    
                    let annotationToRemove = view.annotation
                    self.mapView.removeAnnotation(annotationToRemove!)
                    coreDataStack?.context.delete(location)
                    coreDataStack?.save()
                    
                    break
                }
            }
        } else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "PicCollectionViewController") as! PicCollectionViewController
            
            // Grab the location object from Core Data
            let location = self.getLocation(longitude: coordinate!.longitude, latitude: coordinate!.latitude)
            
            vc.selectedLocation = location
            vc.totalPageNumber = location?.value(forKey: "page") as! Int
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
extension MapViewController{
    func checkReachable()
           {
               var flags = SCNetworkReachabilityFlags()
               SCNetworkReachabilityGetFlags(self.reachability!, &flags) 
               
               if (isNetworkReachable(with: flags))
               {
                   print (flags)
                   if flags.contains(.isWWAN) {
                       //self.alert(message:"via mobile",title:"Reachable")
                       return
                   }
                   
                   //self.alert(message:"via wifi",title:"Reachable")
               }
               else if (!isNetworkReachable(with: flags)) {
                   self.alert(message:"Sorry no connection",title: "unreachable")
                   print (flags)
                   return
               }
           }
           
           
           private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
               let isReachable = flags.contains(.reachable)
               let needsConnection = flags.contains(.connectionRequired)
               let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
               let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
               return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
           }

           /*
           private func setReachabilityNotifier () {
               //declare this inside of viewWillAppear
               
               NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
               do{
                   try reachability.startNotifier()
               }catch{
                   print("could not start reachability notifier")
               }
           }
           */
           
           @objc func reachabilityChanged(note: Notification) {
               
               let reachability = note.object as! Reachability
               
               switch reachability.connection {
               case .wifi:
                   print("Reachable via WiFi")
               case .cellular:
                   print("Reachable via Cellular")
               case .none:
                   print("Network not reachable")
               
               }
           }
    
}
