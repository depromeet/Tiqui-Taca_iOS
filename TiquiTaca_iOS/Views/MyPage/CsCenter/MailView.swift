//
//  MailView.swift
//  TiquiTaca_iOS
//
//  Created by hakyung on 2022/06/16.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {  
  @Binding var isShowing: Bool
  @Binding var result: Result<MFMailComposeResult, Error>?
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    init(isShowing: Binding<Bool>,
         result: Binding<Result<MFMailComposeResult, Error>?>) {
      _isShowing = isShowing
      _result = result
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      defer {
        isShowing = false
      }
      guard error == nil else {
        self.result = .failure(error!)
        return
      }
      self.result = .success(result)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(isShowing: $isShowing,
                       result: $result)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let vc = MFMailComposeViewController()
    vc.mailComposeDelegate = context.coordinator
    return vc
  }
  
  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<MailView>) {
    uiViewController.setToRecipients(["hakyung_song1@kolon.com"])
  }
}
