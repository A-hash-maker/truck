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
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    var viewModel = HomeViewModel()
    var searchBarVisible: Bool = false
    var mapViewVisible: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = AppColor.PRIMARYCOLOR
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
        
        flipBtn.setImage(UIImage(named: "map"), for: .normal)
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        searchBarHeight.constant = 0
        
        flipBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        
        callingAPI()
        viewModel.updateMap = { annotationPoints in
            self.updateMap(annotionPoints: annotationPoints)
        }
        viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = UIColor.white
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }
    
    func updateMap(annotionPoints: [MKPointAnnotation]) {
        
        var counter = 0
        
        for item in annotionPoints {
            self.mapView.addAnnotation(item)
            counter += 1
        }
        
        
        mapView.centerCoordinate = annotionPoints[0].coordinate
//        let coordinate = annotionPoints[0].coordinate
//        let region = self.mapView.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
//        self.mapView.setRegion(region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 40.0, left: 20.0, bottom: 20, right: 20.0), animated: true)
        
//        MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: MKCoordinateSpan()
//        
//        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        let camera = MKMapCamera(lookingAtCenter: annotionPoints[0].coordinate, fromDistance: CLLocationDistance(200), pitch: 100, heading: CLLocationDirection.init(100))
        mapView.setCamera(camera, animated: true)
        
        mapView.showAnnotations(annotionPoints, animated: true)
        print("Total Annotations is \(mapView.annotations)")
        
    }
    
    
    
    
    
    
    @IBAction func flipBtnTapped(sender: UIButton) {
        setView(view: search, hidden: !search.isHidden)
        setView(view: mapView, hidden: !mapView.isHidden)
        setView(view: listTableView, hidden: !listTableView.isHidden)
        if search.isHidden {
            flipBtn.setImage(UIImage(named: "list"), for: .normal)
        }else {
            flipBtn.setImage(UIImage(named: "map"), for: .normal)
        }
    }
    
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        searchBarVisible = !searchBarVisible
        if searchBarVisible {
            searchBarHeight.constant = 55
        }else {
            searchBarHeight.constant = 0
        }
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

