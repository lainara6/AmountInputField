//
//  AmountInputField.swift
//  AmountInputField
//
//  Created by Lai Nara on 5/1/23.
//

import UIKit

open class AmountInputField: UIStackView {

    public var delegate: AmountInputFieldDelegate?

    public var requiredColor: UIColor = .red

    public var errorBorderColor: UIColor = .red

    public var errorBorderWidth: CGFloat = 1.0

    public var normalBorderColor: UIColor = UIColor(red: 194/255.0, green: 194/255.0, blue: 194/255.0, alpha: 1.0) {
        didSet {
            isActive = isActive ? true : false
        }
    }

    public var activeBorderColor: UIColor = UIColor(red: 48/255.0, green: 128/255.0, blue: 220/255.0, alpha: 1.0) {
        didSet {
            isActive = isActive ? true : false
        }
    }

    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular) {
        didSet {
            topPlaceholderLabel.font = UIFont(name: placeholderFont.familyName, size: placeholderFont.pointSize - 2)
            centerPlaceholderLabel.font = placeholderFont
        }
    }

    public var placeholderColor: UIColor = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0) {
        didSet {
            topPlaceholderLabel.textColor = placeholderColor
            centerPlaceholderLabel.textColor = placeholderColor
        }
    }

    public var placeholderText: String = "Enter Amount" {
        didSet {
            topPlaceholderLabel.text = placeholderText
            centerPlaceholderLabel.text = placeholderText
        }
    }

    public var inputBackgroundColor: UIColor = UIColor.clear {
        didSet {
            backgroundColor = inputBackgroundColor
        }
    }

    public var normalBorderWidth: CGFloat = 1 {
        didSet {
            isActive = isActive ? true : false
        }
    }

    public var activeBorderWidth: CGFloat = 2 {
        didSet {
            isActive = isActive ? true : false
        }
    }

    public var cornerRadius: CGFloat = 6 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public var font: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .regular) {
        didSet {
            inputTextField.font = font
        }
    }

    public var textColor: UIColor = UIColor(red: 1/255.0, green: 13/255.0, blue: 16/255.0, alpha: 1.0) {
        didSet {
            inputTextField.textColor = textColor
        }
    }

    public var isRequired: Bool = false {
        didSet {
            if isRequired {
                let topFont = UIFont(name: placeholderFont.familyName, size: placeholderFont.pointSize - 2) ?? UIFont.systemFont(ofSize: placeholderFont.pointSize - 2)
                let topAttributesText: [NSAttributedString.Key: Any] = [.font: topFont, .foregroundColor: placeholderColor]
                let topAttributesAsterisk: [NSAttributedString.Key: Any] = [.font: topFont, .foregroundColor: requiredColor]
                let topAttributedText = NSAttributedString(string: placeholderText, attributes: topAttributesText)
                let topAttributedAsterisk = NSAttributedString(string: " *", attributes: topAttributesAsterisk)
                let topAttributedFullText = NSMutableAttributedString()
                topAttributedFullText.append(topAttributedText)
                topAttributedFullText.append(topAttributedAsterisk)
                topPlaceholderLabel.attributedText = topAttributedFullText

                let centerAttributesText: [NSAttributedString.Key: Any] = [.font: placeholderFont, .foregroundColor: placeholderColor]
                let centerAttributesAsterisk: [NSAttributedString.Key: Any] = [.font: placeholderFont, .foregroundColor: requiredColor]
                let centerAttributedText = NSAttributedString(string: placeholderText, attributes: centerAttributesText)
                let centerAttributedAsterisk = NSAttributedString(string: " *", attributes: centerAttributesAsterisk)
                let centerAttributedFullText = NSMutableAttributedString()
                centerAttributedFullText.append(centerAttributedText)
                centerAttributedFullText.append(centerAttributedAsterisk)
                centerPlaceholderLabel.attributedText = centerAttributedFullText
            }
        }
    }

    public var text: String? = nil {
        didSet {
            if let text = text {
                manipulateInput(text)
                if let text = inputTextField.text, text.count > 0 {
                    topPlaceholderLabel.alpha = 1
                    centerPlaceholderLabel.alpha = 0
                    topConstant = 26
                    bottomConstant = 8
                } else {
                    delegate?.amountInputFieldDidChange(self, value: nil)
                }
            }
        }
    }

    public func becomeError(errorMessage: String?) {
        isError = true
        delegate?.amountInputFieldDidBecomeError(self, errorMessage: errorMessage)
    }

    public func resignError() {
        isError = false
        delegate?.amountInputFieldDidResignError(self)
    }

    private var isError: Bool! = false {
        didSet {
            isActive = isActive ? true : false
        }
    }

    private var isActive: Bool = false {
        didSet {
            if isActive {
                layer.cornerRadius = cornerRadius
                layer.borderWidth = isError ? errorBorderWidth : activeBorderWidth
                layer.borderColor = isError ? errorBorderColor.cgColor : activeBorderColor.cgColor
                if let text = inputTextField.text, text.count == 0 {
                    topPlaceholderLabel.alpha = 1
                    centerPlaceholderLabel.alpha = 0
                }
                topConstant = 26
                bottomConstant = 8
            } else {
                layer.cornerRadius = cornerRadius
                layer.borderWidth = isError ? errorBorderWidth : normalBorderWidth
                layer.borderColor = isError ? errorBorderColor.cgColor : normalBorderColor.cgColor
                if let text = inputTextField.text, text.count == 0 {
                    topPlaceholderLabel.alpha = 0
                    centerPlaceholderLabel.alpha = 1
                    topConstant = 16
                    bottomConstant = 16
                } else {
                    topConstant = 26
                    bottomConstant = 8
                }
            }
        }
    }

    private var topConstant: CGFloat = 0 {
        didSet {
            topConstraint.constant = self.topConstant
        }
    }

    private var bottomConstant: CGFloat = 16 {
        didSet {
            bottomConstraint.constant = -bottomConstant
        }
    }

    private var limitIntegerDigits: Int = 17
    private var contentView: UIView!
    private var inputTextField: UITextField!
    private var stackView: UIStackView!
    private var topPlaceholderLabel: UILabel!
    private var centerPlaceholderLabel: UILabel!
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var inputFormatter: NumberFormatter = {
        let locale = Locale(identifier: "en_US")
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.groupingSeparator = locale.groupingSeparator
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        commitUI()
    }

    private func commitUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true
        if #available(iOS 11.0, *) { directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12) }
        clipsToBounds = true
        backgroundColor = inputBackgroundColor

        contentView = UIView()
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        contentView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addArrangedSubview(contentView)

        inputTextField = UITextField()
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputTextField.keyboardAppearance = .default
        inputTextField.keyboardType = .decimalPad
        inputTextField.delegate = self
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.font = font
        inputTextField.textColor = textColor
        inputTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        inputTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        inputTextField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        inputTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(inputTextField)

        topConstraint = inputTextField.topAnchor.constraint(equalTo: contentView.topAnchor)
        bottomConstraint = inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            inputTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            inputTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])

        centerPlaceholderLabel = UILabel()
        centerPlaceholderLabel.font = placeholderFont
        centerPlaceholderLabel.textColor = placeholderColor
        centerPlaceholderLabel.text = placeholderText
        centerPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        centerPlaceholderLabel.textAlignment = .left
        inputTextField.addSubview(centerPlaceholderLabel)

        NSLayoutConstraint.activate([
            centerPlaceholderLabel.topAnchor.constraint(equalTo: inputTextField.topAnchor),
            centerPlaceholderLabel.rightAnchor.constraint(equalTo: inputTextField.rightAnchor),
            centerPlaceholderLabel.bottomAnchor.constraint(equalTo: inputTextField.bottomAnchor),
            centerPlaceholderLabel.leftAnchor.constraint(equalTo: inputTextField.leftAnchor),
        ])

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 16)
        ])

        topPlaceholderLabel = UILabel()
        topPlaceholderLabel.font = UIFont(name: placeholderFont.familyName, size: placeholderFont.pointSize - 2)
        topPlaceholderLabel.textColor = placeholderColor
        topPlaceholderLabel.text = placeholderText
        topPlaceholderLabel.textAlignment = .left
        stackView.addArrangedSubview(topPlaceholderLabel)

        isActive = false
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.becomeFirstResponder()
    }
}

extension AmountInputField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        isActive = true
        delegate?.amountInputFieldDidBeginEditing(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        isActive = false
        delegate?.amountInputFieldDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return false
        }

        guard let range = Range(range, in: text) else {
            return false
        }

        manipulateInput(text.replacingCharacters(in: range, with: string == Locale.current.decimalSeparator ? inputFormatter.decimalSeparator : string))

        return false
    }

    private func manipulateInput(_ text: String) {
        if text.count > 0 {
            if validateInput(text: text) {
                let localText = text.replacingOccurrences(of: inputFormatter.groupingSeparator, with: "")
                if localText.contains(inputFormatter.decimalSeparator) {
                    var integers = localText.components(separatedBy: inputFormatter.decimalSeparator)
                    if integers.count > 0 {
                        if integers[0].count < (limitIntegerDigits + 1) {
                            if let integerNumber = inputFormatter.number(from: integers[0]) {
                                if let integerTextNumber = inputFormatter.string(from: integerNumber) {
                                    integers[0] = integerTextNumber
                                    let inputTextNumber = integers.joined(separator: inputFormatter.decimalSeparator)
                                    if let inputNumber = inputFormatter.number(from: inputTextNumber) {
                                        inputTextField.text = inputTextNumber
                                        delegate?.amountInputFieldDidChange(self, value: inputNumber.doubleValue)
                                        endingCursor()
                                        resignError()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if localText.count < (limitIntegerDigits + 1) {
                        if let inputNumber = inputFormatter.number(from: localText) {
                            if let inputTextNumber = inputFormatter.string(from: inputNumber) {
                                inputTextField.text = inputTextNumber
                                delegate?.amountInputFieldDidChange(self, value: inputNumber.doubleValue)
                                endingCursor()
                                resignError()
                            }
                        }
                    }
                }
            }
        } else {
            inputTextField.text = nil
            delegate?.amountInputFieldDidChange(self, value: nil)
            endingCursor()
            resignError()
        }
    }

    private func validateInput(text: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: "^(?!0[0-9])[0-9,]+.?[0-9]{0,2}$", options: []) {
            let matches = regex.numberOfMatches(in: text, options: [], range: NSRange(location: 0, length: text.unicodeScalars.count))
            return matches > 0
        }
        return false
    }

    private func endingCursor() {
        DispatchQueue.main.async { self.inputTextField.selectedTextRange = self.inputTextField.textRange(from: self.inputTextField.endOfDocument, to: self.inputTextField.endOfDocument) }
    }
}
