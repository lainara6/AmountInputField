//
//  AmountInputFieldDelegate.swift
//  AmountInputField
//
//  Created by Lai Nara on 5/1/23.
//

import Foundation

public protocol AmountInputFieldDelegate: AnyObject {
    func amountInputFieldDidBecomeError(_ amountInputField: AmountInputField, errorMessage: String?)
    func amountInputFieldDidResignError(_ amountInputField: AmountInputField)
    func amountInputFieldDidBeginEditing(_ amountInputField: AmountInputField)
    func amountInputFieldDidEndEditing(_ amountInputField: AmountInputField)
    func amountInputFieldDidChange(_ amountInputField: AmountInputField, text: String?, value: Double?)
}
