import Mapbox


// Example view controller
class MapboxVC: UIViewController, MGLMapViewDelegate {
    
    var arr_Data = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.contentInset = UIEdgeInsets.zero
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        switch(3){
        case 0:
        mapView.styleURL = MGLStyle.satelliteStyleURL
        case 1:
        mapView.styleURL = MGLStyle.streetsStyleURL
        case 2:
        mapView.styleURL = MGLStyle.lightStyleURL
        default:
            mapView.styleURL = MGLStyle.darkStyleURL
        }
        mapView.tintColor = .lightGray
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 66)
        mapView.zoomLevel = 2
        mapView.showsScale = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView){
        
        getCards(false){
            
            //var coordinates = [CLLocationCoordinate2D]()
            /*
            // Specify coordinates for our annotations.
            let coordinates = [
                CLLocationCoordinate2D(latitude: 0, longitude: 33),
                CLLocationCoordinate2D(latitude: 0, longitude: 66),
                CLLocationCoordinate2D(latitude: 0, longitude: 99)
            ]
            */
            
            // Fill an array with point annotations and add it to the map.
            var pointAnnotations = [MGLPointAnnotation]()
            
            for card in self.arr_Data {
                if (!(card["location"] as! Bool)) {continue}
                let point = MGLPointAnnotation()
                let coordinate = CLLocationCoordinate2D(
                    latitude: card["latitude"] as! Double,
                    longitude: card["longitude"] as! Double)
                point.coordinate = coordinate
                point.title = "\(card["name"] as! String)"
                point.subtitle = "\(card["company"] as! String) \(card["phone"] as! String)"
                pointAnnotations.append(point)
            }
            /*
            for coordinate in coordinates {
                let point = MGLPointAnnotation()
                point.coordinate = coordinate
                point.title = "\(coordinate.latitude), \(coordinate.longitude)"
                pointAnnotations.append(point)
            }
            */
            //mapView.showAnnotations(pointAnnotations, animated: true)
            mapView.addAnnotations(pointAnnotations)
        }
    }
    
    func getCards(_ animate: Bool, completion:@escaping () -> Void) {
        
        if animate {
            ShowProgressHud(message: AppMessage.plzWait)
        }
        
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllBusinessCardsListFromFirebaseStorage() { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    for dict in dataaa {
                        for (_,v) in dict{
                            self.arr_Data.append(v as! [String:Any])
                        }
                    }
                }
                completion()
            }
        }
        
    }
    

    // MARK: - MGLMapViewDelegate methods

    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        /*
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"

        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)

            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
        */
        return MGLAnnotationImage(image: UIImage(named: "map-pin")!, reuseIdentifier: "\(annotation.coordinate.longitude)")
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}


