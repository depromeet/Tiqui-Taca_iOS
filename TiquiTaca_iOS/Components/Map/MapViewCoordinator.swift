//
//  MapViewCoordinator.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

final class MapViewCoordinator: NSObject, MKMapViewDelegate {
  var mapView: MapView
  
  init(_ control: MapView) {
    self.mapView = control
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    self.mapView.region = CoordinateRegion(coordinateRegion: mapView.region)
  }
}
