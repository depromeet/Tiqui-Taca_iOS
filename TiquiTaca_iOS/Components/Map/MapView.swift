//
//  MapView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
  let annotationInfos: [ChatRoomAnnotationInfo]
  @Binding var region: CoordinateRegion?
  @Binding var selectedAnnotationId: String?
  
  init(
    annotationInfos: [ChatRoomAnnotationInfo],
    region: Binding<CoordinateRegion?>,
    selectedAnnotationId: Binding<String?>
  ) {
    self.annotationInfos = annotationInfos
    self._region = region
    self._selectedAnnotationId = selectedAnnotationId
  }
  
  func makeUIView(context: Context) -> MKMapView {
    self.makeView(context: context)
  }
  
  func updateUIView(_ mapView: MKMapView, context: Context) {
    self.updateView(mapView: mapView, delegate: context.coordinator)
  }
  
  func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }
  
  private func makeView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    mapView.showsUserLocation = true
    return mapView
  }
  
  private func updateView(mapView: MKMapView, delegate: MKMapViewDelegate) {
    mapView.delegate = delegate
    
    if let region = self.region {
      mapView.setRegion(region.asMKCoordinateRegion, animated: true)
    }
    
    let currentlyDisplayedInfos = mapView.annotations.compactMap { $0 as? ChatRoomAnnotation }
      .map { $0.info }
    
    let addedInfos = Set(annotationInfos).subtracting(currentlyDisplayedInfos)
    let removedInfos = Set(currentlyDisplayedInfos).subtracting(annotationInfos)
    
    let addedAnnotations = addedInfos.map(ChatRoomAnnotation.init(info:))
    let removedAnnotations = mapView.annotations.compactMap { $0 as? ChatRoomAnnotation }
      .filter { removedInfos.contains($0.info) }
    
    mapView.removeAnnotations(removedAnnotations)
    mapView.addAnnotations(addedAnnotations)
  }
}
