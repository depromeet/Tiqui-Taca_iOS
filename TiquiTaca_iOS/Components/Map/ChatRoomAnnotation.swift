//
//  ChatRoomAnnotation.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

final class ChatRoomAnnotation: NSObject, MKAnnotation {
  let info: ChatRoomAnnotationInfo
  
  init(info: ChatRoomAnnotationInfo) {
    self.info = info
  }
  
  var coordinate: CLLocationCoordinate2D {
    return info.coordinate
  }
  
  var title: String? {
    return "\(info.userCount)명"
  }
  
  var subtitle: String? {
    return info.name
  }
  
  var imageName: String {
    return info.category
  }
}
