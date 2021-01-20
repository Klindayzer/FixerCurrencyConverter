/*
 *	APIErrors.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

struct APIErrors: Codable {
    let success: Bool?
    let error: APIError?
}

struct APIError: Codable {
    let code: Int
    let type: String
}
