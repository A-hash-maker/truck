//
//  HomeViewModel.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import Foundation
import UIKit
import SwiftyJSON
import MapKit


class HomeViewModel: NSObject {
    
    var truckViewModel: TruckViewModel?
    var truckArray = [Truck]()
    var updateMap: ((_ annotationPoints: [MKPointAnnotation]) -> Void)?
    var reloadTableView: (() -> Void)?
    
    func callingHTTPAPI(api: String, completion: @escaping ((_ success: Bool) -> Void)) {
        NetworkManager.shared.callingHTTPAPI(urlString: api) { responseData, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let responseData = responseData else {
                completion(false)
                return
            }

            self.doFurtherProcessingWithData(response: responseData) { success in
                completion(true)
            }
        }
    }
    
    
    func doFurtherProcessingWithData(response: JSON, completion: @escaping ((_ success: Bool) -> Void)) {
        self.truckViewModel = TruckViewModel(json: response)
        
        guard let truckModel = truckViewModel else { return }
        
        truckArray.removeAll()
        
        for item in truckModel.data {
            truckArray.append(item)
        }

        completion(true)
    }
    
    func addAnnotation() {
        
        if let truckModel = truckViewModel {
            var annotataionPoints = [MKPointAnnotation]()
            for item in truckModel.data {
                let latitute = item.lastWaypoint?.lat ?? 0.0
                let longitude = item.lastWaypoint?.lng ?? 0.0
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees.init(latitute), longitude: CLLocationDegrees.init(longitude))
                
                if item.lastWaypoint?.speed != 0 {
                    annotation.title = TruckStatus.running.rawValue
//                    annotation.truckStatus = "running"
                }else if item.lastWaypoint?.speed == 0 && item.lastWaypoint?.ignitionOn == true {
                    annotation.title = TruckStatus.stopped.rawValue
//                    annotation.truckStatus = "stopped"
                }else if item.lastWaypoint?.speed == 0 && item.lastWaypoint?.ignitionOn == false {
                    annotation.title = TruckStatus.idle.rawValue
//                    annotation.truckStatus = "idle"
                }else {
                    annotation.title = TruckStatus.error.rawValue
//                    annotation.truckStatus = "error"
                }
                
                annotataionPoints.append(annotation)
            }
            updateMap!(annotataionPoints)
        }
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return truckArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TruckListTableViewCell", for: indexPath) as? TruckListTableViewCell {
            cell.item = truckArray[indexPath.row]
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 0.5
            cell.layer.shadowColor = AppColor.LIGHTGREYCOLOR.cgColor
            cell.layer.shadowRadius = 0.5
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.layer.borderColor = AppColor.LIGHTGREYCOLOR.cgColor
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

// MARK:- MKMapViewDelegate
extension HomeViewModel: MKMapViewDelegate {
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("Unable to load the Map -> \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else {
                return nil
            }
        
            // Better to make this class property
            let annotationIdentifier = "AnnotationIdentifier"

            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }else {
                let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = av
            }
        
            if let annotationView = annotationView {
                // Configure your annotation view here
                annotationView.image?.withRenderingMode(.alwaysTemplate)
                annotationView.canShowCallout = true
                var image = UIImage()
                if annotation.title == TruckStatus.running.rawValue {
//                    image = UIImage(named: "truck")!.withTintColor(AppColor.GREENCOLOR)
                    image = UIImage(named: "truck")!.colorized(color: AppColor.GREENCOLOR)
//                    colorized
                    annotationView.tintColor = AppColor.GREENCOLOR
                }else if annotation.title == TruckStatus.stopped.rawValue {
//                    image = UIImage(named: "truck")!.withTintColor(AppColor.BLUECOLOR)
                    
                    image = UIImage(named: "truck")!.colorized(color: AppColor.BLUECOLOR)
                    
                    annotationView.tintColor = AppColor.BLUECOLOR
                }else if annotation.title == TruckStatus.idle.rawValue {
//                    image = UIImage(named: "truck")!.withTintColor(AppColor.YELLOWCOLOR)
                    
                    image = UIImage(named: "truck")!.colorized(color: AppColor.YELLOWCOLOR)
                    
                    annotationView.tintColor = AppColor.YELLOWCOLOR
                }else if annotation.title == TruckStatus.error.rawValue {
//                    image = UIImage(named: "truck")!.withTintColor(AppColor.REDCOLOR)
                    
                    image = UIImage(named: "truck")!.colorized(color: AppColor.REDCOLOR)
                    
                    annotationView.tintColor = AppColor.REDCOLOR
                }
                annotationView.image = image
            }
            return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    
    
}

//MARK:- UISearchBarDelegate

extension HomeViewModel: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let truckModel = truckViewModel else { return }
        
        truckArray.removeAll()
        if searchText.count != 0 {
            for item in truckModel.data {
                if item.truckNumber.contains(searchText) {
                    truckArray.append(item)
                }
            }
        }else {
            truckArray = truckModel.data
        }
        
        reloadTableView!()
        
    }
    
    
}

//extension MKAnnotation {
//
//    var truckStatus: String! {
//        get {
//            return self.truckStatus
//        }
//        set(newValue) {
//            self.truckStatus = newValue
//        }
//    }
//}

enum TruckStatus {
    case running
    case stopped
    case idle
    case error
    
    var rawValue: String {
        switch self {
        case .running: return "running"
        case .stopped: return "stopped"
        case .idle: return "idle"
        case .error: return "error"
        }
    }
}
