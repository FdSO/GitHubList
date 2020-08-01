//
//  ExtensionUIViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertController(title: String?, message: String?, preferredStyle: UIAlertController.Style, completion: (() -> Void)? = nil) {
        if presentedViewController == nil {
            let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            
            let okAction: UIAlertAction = .init(title: "OK", style: .default) { (_) in
                completion?()
            }
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
        }
    }
}
