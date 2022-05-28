//
//  MapKit+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/22.
//

import MapKit

extension MKCoordinateRegion: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.center.latitude == rhs.center.latitude
    && lhs.center.longitude == rhs.center.longitude
    && lhs.span.latitudeDelta == rhs.span.latitudeDelta
    && lhs.span.longitudeDelta == rhs.span.longitudeDelta
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.latitude == rhs.latitude
    && lhs.longitude == rhs.longitude
  }
}
