/*
 *	CalculatorViewController.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit


class CalculatorViewController: BaseController {
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var baseTextField: UITextField!
    @IBOutlet private weak var selectedTextField: UITextField!
    @IBOutlet private weak var baseLabel: UILabel!
    @IBOutlet private weak var selectedLabel: UILabel!
    
    
    // MARK: - Properties
    private(set) var viewModel = HomeViewModel()
    
    // MARK: - Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: - Exposed Methods
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Protected Methods
    private func initViews() {
        
        baseTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        baseLabel.text = viewModel.baseCurrency?.code
        selectedLabel.text = viewModel.selectedCurrency?.code
        baseTextField.text = "1"
        calculateRate()
    }
    
    @objc private func textFieldDidChange() {
        calculateRate()
    }
    
    private func calculateRate() {
        
        // Validate Input
        guard let baseText = baseTextField.text, !baseText.isEmpty else {
            selectedTextField.text = "0"
            return
        }
        
        guard let base = Double(baseText),
            let selected = viewModel.selectedCurrency?.value else {
                return
        }
        
        selectedTextField.text = "\(viewModel.calculateRate(base: base, selected: selected))"
    }
}
