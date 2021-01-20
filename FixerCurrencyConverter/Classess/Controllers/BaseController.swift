/*
 *	BaseController.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit
import MBProgressHUD

class BaseController: UIViewController {
    
    // MARK: - Exposed Methods
    func showLoader() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoader() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showErrorAlert(message: String, callback: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "Opps!", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            callback(true)
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            callback(false)
        }
        alert.addAction(retryAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
