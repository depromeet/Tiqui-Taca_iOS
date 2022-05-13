//
//  MapView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MapView: View {
  let store: Store<MapState, MapAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Text("MapTab")
        
        Button {
          viewStore.send(.logout)
        } label: {
          Text("Logout")
        }
      }
    }
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(
      store: .init(
        initialState: MapState(),
        reducer: mapReducer,
        environment: MapEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
