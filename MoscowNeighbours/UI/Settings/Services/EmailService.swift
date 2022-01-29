//
//  EmailService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.01.2022.
//

import Foundation
import MessageUI

enum EmailServiceErrors: Error {
    case cantSendMail
}

protocol EmailProvider {
    func showEmailComposer(recipient: String,
                           subject: String?,
                           content: String?,
                           controller: UIViewController?) throws
}

final class EmailService: NSObject, EmailProvider {
    
    func showEmailComposer(recipient: String,
                           subject: String?,
                           content: String?,
                           controller: UIViewController?) throws {
        guard MFMailComposeViewController.canSendMail() else {
            throw EmailServiceErrors.cantSendMail
        }

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([recipient])
        if let subject = subject {
            composer.setSubject(subject)
        }
        if let content = content {
            composer.setMessageBody(content, isHTML: false)
        }
        controller?.present(composer, animated: true, completion: nil)
    }
    
}

// MARK: - Protocol MFMailComposeViewControllerDelegate

extension EmailService: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }

        controller.dismiss(animated: true, completion: nil)
    }

}
