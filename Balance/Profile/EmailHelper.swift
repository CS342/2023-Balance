//
//  EmailHelper.swift
//  Balance
//
//  Created by Gonzalo Perisset on 17/07/2023.
//

import MessageUI
import SwiftUI

// swiftlint:disable modifier_order
// swiftlint:disable force_unwrapping
// swiftlint:disable unused_closure_parameter
// swiftlint:disable legacy_objc_type
class EmailHelper: NSObject {
    static let shared = EmailHelper()
    private override init() {}
}

extension EmailHelper {
    func send(subject: String, body: String, file: URL, to: [String]) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        guard let viewController = windowScene?.windows.first?.rootViewController else {
            return
        }
        
        if !MFMailComposeViewController.canSendMail() {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let mails = to.joined(separator: ",")
            
            let alert = UIAlertController(title: "Cannot open Mail!", message: "", preferredStyle: .actionSheet)
            
            var haveExternalMailbox = false
            
            if let url = createEmailUrl(to: mails, subject: subjectEncoded, body: bodyEncoded), UIApplication.shared.canOpenURL(url) {
                haveExternalMailbox = true
                alert.addAction(UIAlertAction(title: "Gmail", style: .default, handler: { action in
                    UIApplication.shared.open(url)
                }))
            }
            
            if haveExternalMailbox {
                alert.message = "Would you like to open an external mailbox?"
            } else {
                alert.message = "Please add your mail to Settings before using the mail service."
                
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    alert.addAction(UIAlertAction(title: "Open Settings App", style: .default, handler: { action in
                        UIApplication.shared.open(settingsUrl)
                    }))
                }
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: false)
        mailCompose.setToRecipients(to)
        mailCompose.mailComposeDelegate = self
        
        if let data = NSData(contentsOf: file) {
            mailCompose.addAttachmentData(data as Data, mimeType: "application/csv", fileName: "export.csv")
        }
            
        viewController.present(mailCompose, animated: true, completion: nil)
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension EmailHelper: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
