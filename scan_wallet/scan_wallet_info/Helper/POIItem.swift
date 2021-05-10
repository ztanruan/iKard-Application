//
//  POIItem.swift
//  GoogleMapsClustersTest
//
//  Created by ****** ****** on 03.11.2020.
//

import GoogleMaps

class POIItem: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    var marker: GMSMarker?
    var dic_UserData = [String: Any]()

    init(position: CLLocationCoordinate2D, marker: GMSMarker, dic: [String: Any]) {
        self.position = position
        self.marker = marker
        self.dic_UserData = dic
  }
}
