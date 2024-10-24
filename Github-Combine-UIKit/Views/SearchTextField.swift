//
//  SearchTextField.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 07/08/2024.
//

import UIKit

@objc protocol SearchTextFieldDelegate: AnyObject {
    func clearButtonPressed(view: SearchTextField)
    @objc
    optional func textFieldDidChange(_ view: SearchTextField, text: String)
    @objc
    optional func searchButtonPressed(_ view: SearchTextField)
    @objc
    optional func textFieldLostFocus(_ view: SearchTextField)
}

class SearchTextField: UITextField {
    
    // MARK: - Constants
    private enum Constants {
        static let defaultColor: CGColor = UIColor.lightGray.cgColor
        static let focusedColor: CGColor = UIColor.gray.cgColor
        static let disabledAlpha: CGFloat = 0.38
    }

    // MARK: - Views
    private var searchButton = UIButton()
    private var clearButton = UIButton()
    
    // MARK: - Properties
    var pasteEditActionEnabled: Bool = true

    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }

    private var textInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: Margins.m16.rawValue,
            bottom: 0,
            right: (Margins.m16.rawValue * 2) + Size.s24.rawValue
        )
    }
    
    override var isEnabled: Bool {
        didSet {
            setEnableStatus()
        }
    }
    
    private var clearButtonEnabled: Bool?
    
    // Delegation
    weak var searchTextFieldDelegate: SearchTextFieldDelegate?

    init() {
        super.init(frame: CGRect.zero)
        
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.tintColor = .lightGray
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.defaultColor
        self.layer.cornerRadius = Radius.r6.rawValue
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.clipsToBounds = true
        self.returnKeyType = .search
             
        clearButton.setImage(UIImage(systemName: Symbols.clear.rawValue), for: .normal)
        clearButton.imageView?.tintColor = .black
        clearButton.imageView?.contentMode = .scaleAspectFit
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        addSubview(clearButton)
        
        searchButton.setImage(UIImage(systemName: Symbols.search.rawValue), for: .normal)
        searchButton.imageView?.tintColor = .black
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.isHidden = false
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        addSubview(searchButton)

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupConstraints() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Margins.m16.rawValue).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: Size.s24.rawValue).isActive = true

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Margins.m16.rawValue).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: Size.s24.rawValue).isActive = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) && pasteEditActionEnabled == false {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    func setEnableStatus() {
        if isEnabled {
            alpha = 1
            isUserInteractionEnabled = true
        } else {
            alpha = Constants.disabledAlpha
            isUserInteractionEnabled = false
        }
    }
    
    @objc
    fileprivate func handleEditing() {
        updateState()
        updateRightComponent()
    }
    
    @objc
    private func clearButtonPressed() {
        self.text = nil
        searchTextFieldDelegate?.clearButtonPressed(view: self)
        updateRightComponent()
    }
    
    @objc
    private func searchButtonPressed() {
        searchTextFieldDelegate?.searchButtonPressed?(self)
    }
    
    @objc
    fileprivate func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        searchTextFieldDelegate?.textFieldDidChange?(self, text: text)
    }
    
    private func updateRightComponent() {
        clearButton.isHidden = isFirstResponder || isEmpty
        searchButton.isHidden = clearButton.isHidden == false
    }
    
    private func updateState() {
        let borderColor = isFirstResponder ? Constants.focusedColor : Constants.defaultColor
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = self.isEnabled ? borderColor : UIColor(cgColor: borderColor).withAlphaComponent(Constants.disabledAlpha).cgColor
        }
    }
}
