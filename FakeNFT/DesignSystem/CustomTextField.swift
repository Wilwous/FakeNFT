//
//  CustomTextField.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 29.06.2024.
//

import UIKit

final class CustomTextField: UIView {
    
    // MARK: - Public Properties
    
    var text: String? {
        get {
            return textView.text == placeholder ? "" : textView.text
        }
        set {
            textView.text = newValue?.isEmpty ?? true ? placeholder : newValue
            textView.textColor = newValue?.isEmpty ?? true ? .lightGray : .ypBlackDay
        }
    }
    
    var textViewInstance: UITextView {
        return textView
    }
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let clearButton = UIButton(type: .system)
    
    private var placeholder: String
    
    // MARK: - Initializer
    
    init(title: String, placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupUI(title: title, placeholder: placeholder)
        setupConstraints()
        configureClearButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    func setBorder(color: UIColor, width: CGFloat) {
        textView.layer.borderColor = color.cgColor
        textView.layer.borderWidth = width
    }
    
    //MARK: - Private Methods
    
    private func setupUI(title: String, placeholder: String) {
        titleLabel.text = title
        titleLabel.font = .bodyBold
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.backgroundColor = .ypLightGrayDay
        textView.layer.cornerRadius = 12
        textView.font = .bodyRegular
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 40)
        textView.delegate = self
        textView.returnKeyType = .done
        
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(clearButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            clearButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8),
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 16),
            clearButton.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureClearButton() {
        clearButton.isHidden = true
    }
    
    // MARK: - Action
    
    @objc private func clearText() {
        textView.text = ""
        textView.textColor = .ypBlackDay
        clearButton.isHidden = true
        textView.becomeFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension CustomTextField: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .ypBlackDay
        }
        clearButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        clearButton.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        clearButton.isHidden = textView.text.isEmpty
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
