//
//  CoordicateRegion.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

struct CoordinateRegion: Equatable {
  var center: CLLocationCoordinate2D
  var span: MKCoordinateSpan
  
  init(
    center: CLLocationCoordinate2D,
    span: MKCoordinateSpan
  ) {
    self.center = center
    self.span = span
  }
  
  init(coordinateRegion: MKCoordinateRegion) {
    center = coordinateRegion.center
    span = coordinateRegion.span
  }
  
  var asMKCoordinateRegion: MKCoordinateRegion {
    .init(center: center, span: span)
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.center.latitude == rhs.center.latitude
    && lhs.center.longitude == rhs.center.longitude
    && lhs.span.latitudeDelta == rhs.span.latitudeDelta
    && lhs.span.longitudeDelta == rhs.span.longitudeDelta
  }
}
