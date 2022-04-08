//
//  ViewController.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import UIKit
import MapKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flipBtn: UIButton!

    var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = viewModel
        listTableView.dataSource = viewModel
        listTableView.register(UINib(nibName: "TruckListTableViewCell", bundle: nil), forCellReuseIdentifier: "TruckListTableViewCell")
        
        mapView.delegate = viewModel
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.mapType = .standard
        self.navigationItem.title = "Trucks"
        
        search.delegate = viewModel
        search.placeholder = "Enter Truck Number"
        
        callingAPI()
        viewModel.updateMap = { annotationPoints in
            self.updateMap(annotionPoints: annotationPoints)
        }
        viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    
    func updateMap(annotionPoints: [MKPointAnnotation]) {
        
        var counter = 0
        
        for item in annotionPoints {
            item.title = "\(counter)"
            self.mapView.addAnnotation(item)
            annotionPoints[counter].title = "\(counter)"
            counter += 1
        }
        
        mapView.centerCoordinate = annotionPoints[0].coordinate
        mapView.showAnnotations(annotionPoints, animated: true)
        print("Total Annotations is \(mapView.annotations)")
        
    }
    
    
    @IBAction func flipBtnTapped(sender: UIButton) {
        
        setView(view: search, hidden: !search.isHidden)
        setView(view: mapView, hidden: !mapView.isHidden)
        setView(view: listTableView, hidden: !listTableView.isHidden)
        
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    
    func callingAPI() {

        let apiString = "https://api.mystral.in/tt/mobile/logistics/searchTrucks?auth-company=PCH&companyId=33&deactivated=false&key=g2qb5jvucg7j8skpu5q7ria0mu&q-expand=true&q-include=lastRunningState,lastWaypoint"
        
        viewModel.callingHTTPAPI(api: apiString) { success in
            if success {
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                    self.viewModel.addAnnotation()
                }
            }
        }
        
    }


}

