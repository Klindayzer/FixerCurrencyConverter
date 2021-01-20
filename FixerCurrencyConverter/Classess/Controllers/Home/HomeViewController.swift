//
//  HomeViewController.swift
//  FixerCurrencyConverter
//
//  Created by Adham Alkhateeb on 20/01/2021.
//  Copyright © 2021 Fixer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

final class HomeViewController: BaseController {
    
    // MARK: Definitions
    enum Segue: String {
        case calculator = "showCalculator"
    }
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var baseCurrencyButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Properties
    private(set) var viewModel = HomeViewModel()
    
    
    // MARK: - Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadCurrencies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.calculator.rawValue,
            let viewController = segue.destination as? CalculatorViewController {
            viewController.configure(with: viewModel)
        }
    }
    
    
    // MARK: - Protected Methods
    private func setupTableView() {
        tableView.register(CurrencyCell.self) // Register custom cells
    }
    
    private func loadCurrencies(base: Currency? = nil) {
        
        showLoader()
        viewModel.loadCurrencies(baseCurrency: base) { [weak self] error in
            
            defer {
                self?.hideLoader()
            }
            
            if let error = error {
                self?.handleError(error: error)
            } else {
                self?.handleSucces()
            }
        }
    }
    
    private func handleError(error: ServiceError) {
        
        
        showErrorAlert(message: error.message) { retry in
            if retry {
                self.loadCurrencies(base: self.viewModel.baseCurrency)
            } else {
                self.viewModel.baseCurrency = self.viewModel.defaultCurrency
                self.baseCurrencyButton.setTitle(self.viewModel.baseCurrency?.code, for: .normal)
            }
        }
    }
    
    private func handleSucces() {
        
        baseCurrencyButton.setTitle(viewModel.baseCurrency?.code, for: .normal)
        tableView.reloadData()
    }
    
    private func handleBaseCurrencySelection(at index: Int) {
        
        viewModel.baseCurrency = viewModel.item(at: index)
        baseCurrencyButton.setTitle(viewModel.baseCurrency?.code, for: .normal)
        loadCurrencies(base: viewModel.baseCurrency)
    }
    
    
    // MARK: - @IBActions
    @IBAction func changeBaseCurrencyClicked(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select Currency", rows: viewModel.currencyCodes, initialSelection: 0, doneBlock: { _, index, _ in
            self.handleBaseCurrencySelection(at: index)
            
        }, cancel: { _ in
            return
            
        }, origin: sender)
    }
}
