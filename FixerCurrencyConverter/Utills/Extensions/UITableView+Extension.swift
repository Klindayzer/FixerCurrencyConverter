/*
 *	UITableView+Extension.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        
        let bundle = Bundle(for: T.self)
        let nib =  UINib(nibName: T.name, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.name)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.name, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.name)")
        }
        return cell
    }
}
