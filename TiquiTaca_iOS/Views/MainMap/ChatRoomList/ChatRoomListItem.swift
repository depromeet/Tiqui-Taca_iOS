//
//  ChatRoomListItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/05.
//

import SwiftUI
import CoreLocation

struct ChatRoomListItem: View {
  let roomInfo: RoomFromCategoryResponse
  let currentLocation: CLLocation
  
  private var distanceString: String {
    let distance = roomInfo.distance(from: currentLocation)
    return distance.prettyDistance
  }
  
  var body: some View {
    HStack(spacing: .spacingS) {
      Text(roomInfo.name)
        .font(.subtitle2)
        .foregroundColor(.white)
      Spacer()
      Text(distanceString)
        .font(.body3)
        .foregroundColor(.black100)
    }
    .padding(.vertical, .spacingM)
    .padding(.horizontal, .spacingXL)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(Color.black600)
        .frame(height: 1)
    }
  }
}

struct ChatRoomListItem_Previews: PreviewProvider {
  static var previews: some View {
    ChatRoomListItem(
      roomInfo: .init(),
      currentLocation: .init(latitude: 0, longitude: 0)
    )
    .background(Color.black700)
    .previewLayout(.sizeThatFits)
  }
}
