import UIKit
import Firebase
import GoogleMaps
import CoreLocation

class MapVC: UIViewController, GMSMapViewDelegate {

    var clusterManager: GMUClusterManager?
    var arr_Data = [[String: Any]]()
    @IBOutlet weak var btn_Add: UIControl!
    let locationManager = CLLocationManager()
    @IBOutlet weak var view_BaseMapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getLocation()
        if self.LocationPermissionEnambleorNot() {
            //self.getScannedBusinseeCard(true)
            print("Location services enabled")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.setCurrentLocation()
            }
        }
        else {
            print("Location services are not enabled")
            self.tabBarController?.view.makeToast("Please enable location access")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if appDelegate.str_scannedQR_CODE != "" {
            //Scanned QR Code
            print("Scannned QR Code==========>>\(appDelegate.str_scannedQR_CODE)")
            self.getParticular_BusinessCard_fromQRCode(appDelegate.str_scannedQR_CODE)
        }
        else {
            self.getScannedBusinseeCard(false)
        }
    }
    
    @objc func pulltoRefresh() {
        self.getScannedBusinseeCard(false)
    }
    
    
    func getParticular_BusinessCard_fromQRCode(_ qr_code: String) {
        
        appDelegate.str_scannedQR_CODE = ""
        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetParticularBusinessCardsFromFirebaseStorage(scanned_qr_code: qr_code) { (is_added) in
                DismissProgressHud()
                if is_added {
                    self.getScannedBusinseeCard(true)
                }
            }
        }
    }
    
    func getScannedBusinseeCard(_ animate: Bool) {
        
        if animate {
            ShowProgressHud(message: AppMessage.plzWait)
        }
        
        DispatchQueue.main.async {
            FirebaseManager.shared.GetScannedBusinessCardsListFromFirebaseStorage() { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arr_Data.removeAll()
                    for diccc in dataaa {
                        let is_location = diccc["location"] as? Bool ?? false
                        if is_location {
                            self.arr_Data.append(diccc)
                        }
                    }
                }
                self.setupClusters()
                self.setMapPoints()
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UIButton Action Method
    @IBAction func btn_Add_Action(_ sender: UIControl) {
        let objScan = Story_Main.instantiateViewController(withIdentifier: "ScanVC") as! ScanVC
        self.navigationController?.pushViewController(objScan, animated: true)
    }
}

//MARK: - MAP VIEW Delegate Method
extension MapVC: CLLocationManagerDelegate {

    // MARK : - Other Methods
    func setCurrentLocation() {
        //-------Set Current Location------------//
        self.view_BaseMapView.delegate = self
        self.view_BaseMapView.isMyLocationEnabled = true
        self.view_BaseMapView.settings.myLocationButton = true
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude:
                                                                    appDelegate.currentLatitude, longitude: appDelegate.currentLongitude, zoom: 12.0)
        self.view_BaseMapView.camera = camera
    }
    
    
    // MARK: - GET LOCATION
    func getLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Map Screen locations = \(locValue.latitude) \(locValue.longitude)")
        appDelegate.currentLatitude = locValue.latitude
        appDelegate.currentLongitude = locValue.longitude
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            //print("user allow app to get location data only when app is active")
            //print("user allow app to get location data when app is active or in background")

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.setCurrentLocation()
                self.getScannedBusinseeCard(true)
                NotificationCenter.default.post(name: NSNotification.Name.init("LOCATIONPERMISSIONNOTIFICATION"), object: nil)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed Notification")
    }
    
    
    func setMapPoints() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if self.arr_Data.count == 0 {
                self.view_BaseMapView.clear()
            }

            var is_mapClear = true
            
            for dicResult in self.arr_Data {
                if is_mapClear {
                    is_mapClear = false
                    self.view_BaseMapView.clear()
                }

                self.createClusters(dic_data: dicResult)
            }
        }
    }
    
    func LocationPermissionEnambleorNot() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
    
}


//MARK: - SET UP CLUSTER
extension MapVC: GMUClusterManagerDelegate, GMUClusterIconGenerator, GMUClusterRendererDelegate {
    
    func icon(forSize size: UInt) -> UIImage! {
        return #imageLiteral(resourceName: "icon_blue_circle")
    }

    func setupClusterManager() {
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        // Set up the cluster manager with the supplied icon generator and renderer.
        let clusterIconImage = #imageLiteral(resourceName: "icon_blue_circle")
        let imagesArray = [clusterIconImage]
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [99], backgroundImages: imagesArray)
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        // Generate and add random items to the cluster manager.
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        guard let mapView = self.view_BaseMapView else { return }
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager?.cluster()
    }
    
    func setupClusters() {
        setupClusterManager()
        clusterManager?.setDelegate(self, mapDelegate: self)
    }
    
    func createClusters(dic_data: [String: Any]) {
        let latitude = dic_data["latitude"] as? Double ?? 0.0
        let longitude = dic_data["longitude"] as? Double ?? 0.0
        let location = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: location)
        let item = POIItem(position: location, marker: marker, dic: dic_data)
        clusterManager?.add(item)
        clusterManager?.cluster()
    }

    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData as? POIItem != nil {
            if let diccc = (marker.userData as? POIItem)?.dic_UserData {
                marker.icon = #imageLiteral(resourceName: "icons8-map-pin-400")
                let strComp = diccc["company"] as? String ?? ""
                let strphone = diccc["phone"] as? String ?? ""
                marker.title = diccc["name"] as? String ?? ""
                marker.snippet = "\(strComp)\n\(strphone)"
                marker.appearAnimation = .pop
            }
        }
    }
}
