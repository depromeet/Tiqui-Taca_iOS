//
//  MainMapView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture
import ComposableCoreLocation

struct MainMapView: View {
  let store: Store<MainMapState, MainMapAction>
  
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

struct MainMapView_Previews: PreviewProvider {
  static var previews: some View {
    MainMapView(
      store: .init(
        initialState: .init(),
        reducer: mainMapReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
