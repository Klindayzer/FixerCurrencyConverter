/*
 *	CurrencyCell.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit

final class CurrencyCell: UITableViewCell {
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    
    // MARK: - Overridden Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    
    // MARK: - Exposed Methods
    func setupCell(currency: Currency) {
        
        titleLabel.text = currency.code
        valueLabel.text = "\(currency.value)"
    }
}
