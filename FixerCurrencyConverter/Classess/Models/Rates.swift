/*
 *	Rates.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

struct Rates: Resultable {
    let timestamp: Int?
    let base: String?
    let date: String?
    let rates: [String: Double]?
}
