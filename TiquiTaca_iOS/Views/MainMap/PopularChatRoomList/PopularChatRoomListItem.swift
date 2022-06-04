//
//  PopularChatRoomListItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import SwiftUI
import CoreLocation

struct PopularChatRoomListItem: View {
  let roomInfo: RoomFromCategoryResponse
  let rankingNumber: Int
  let currentLocation: CLLocation
  
  private var userCountString: String {
    return "\(roomInfo.userCount)" + "명"
  }
  
  private var subString: String {
    let categoryName = roomInfo.category?.locationName ?? ""
    let location = CLLocation(latitude: roomInfo.latitude, longitude: roomInfo.longitude)
    let distance = currentLocation.distance(from: location)
    let distanceString = String(Int(distance))
    return categoryName + " | " + distanceString + "m"
  }
  
  var body: some View {
    HStack(spacing: .spacingS) {
      ZStack {
        Image("colorStar")
          .resizable()
          .frame(width: 32, height: 32)
          .padding(.spacingXXS)
        Text("\(rankingNumber)")
          .font(.heading3)
          .foregroundColor(.black700)
      }
      VStack(alignment: .leading, spacing: .spacingXXXS) {
        Text(roomInfo.name)
          .font(.heading3)
          .foregroundColor(.white)
        Text(subString)
          .font(.body3)
          .foregroundColor(.black100)
      }
      Spacer()
      VStack(spacing: 0) {
        Image("peopleColor")
          .resizable()
          .frame(width: 24, height: 24)
        Text(userCountString)
          .font(.subtitle4)
          .foregroundColor(.white500)
      }
    }
    .padding(.vertical, .spacingS)
    .padding(.horizontal, .spacingXL)
  }
}

struct PopularChatRoomListItem_Previews: PreviewProvider {
  static var previews: some View {
    PopularChatRoomListItem(
      roomInfo: .init(),
      rankingNumber: 0,
      currentLocation: .init(latitude: 0, longitude: 0)
    )
    .background(Color.black700)
    .previewLayout(.sizeThatFits)
  }
}
