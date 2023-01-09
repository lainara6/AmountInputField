//
//  AmountErrorField.swift
//  AmountInputField
//
//  Created by Lai Nara on 9/1/23.
//

import UIKit

open class AmountErrorField: UIStackView {

    public var font: UIFont! = nil {
        didSet {
            errorLabel.font = font
        }
    }

    public var textColor: UIColor! = nil {
        didSet {
            errorLabel.textColor = textColor
        }
    }

    public var errorMessage: String! = nil {
        didSet {
            isHidden = errorMessage == nil
            errorLabel.text = errorMessage
        }
    }

    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AmountError")
        return imageView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        commitUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commitUI()
    }

    private func commitUI() {
        isHidden = true
        backgroundColor = .clear
        axis = .horizontal
        spacing = 4
        addArrangedSubview(errorImageView)
        addArrangedSubview(errorLabel)
        errorImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        errorImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        errorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        errorLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
