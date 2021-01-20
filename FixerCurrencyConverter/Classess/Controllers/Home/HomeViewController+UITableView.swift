/*
 *	HomeViewController+UITableView.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CurrencyCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let currency = viewModel.item(at: indexPath.row)
        cell.setupCell(currency: currency)
        return cell
    }
}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedCurrency = viewModel.item(at: indexPath.row)
        performSegue(withIdentifier: Segue.calculator.rawValue, sender: nil)
    }
}
