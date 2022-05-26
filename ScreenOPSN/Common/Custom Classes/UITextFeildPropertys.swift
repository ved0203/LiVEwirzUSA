//
//  UITextFeildPropertys.swift
//  Fantasy11
//
//  Created by mac on 28/06/18.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation
import UIKit

class UITextFeildPropertys: UITextField, UITextFieldDelegate {
    private var characterLimit: Int?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        applyStyles()
    }

    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    /// Applies border to the text view with the specified width
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }
    /// Sets the color of the border
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    /// Make the corners rounded with the specified radius
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    /// Applies underline to the text view with the specified width
    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }

    /// Sets the underline color
    @IBInspectable public var underLineColor: UIColor = .groupTableViewBackground {
        didSet {
            updateUnderLineUI()
        }
    }
    /// Sets the placeholder color
    @IBInspectable public var placeholderColor: UIColor = .lightGray {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])

        }
    }
    public override var placeholder: String? {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    /// Sets left margin
    @IBInspectable public var leftMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }
    /// Sets right margin
    @IBInspectable public var rightMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
        updateAccessoryViewFrame()
    }
    // MARK: - Styles
    private func applyStyles() {
        applyUnderLine()
        setMargins()
    }
    // MARK: - Underline
    private var underLineLayer = CALayer()
    private func applyUnderLine() {
        // Apply underline only if the text view's has no borders
        if borderStyle == UITextField.BorderStyle.none {
            underLineLayer.removeFromSuperlayer()
            updateUnderLineFrame()
            updateUnderLineUI()
            layer.addSublayer(underLineLayer)
            layer.masksToBounds = true
        }
    }
    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }
    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }
    // MARK: - Margins
    private var leftAcessoryView = UIView()
    private var rightAcessoryView = UIView()
    private func setMargins() {
        // Left Margin
        leftView = nil
        leftViewMode = .never
        if leftMargin > 0 {
            if nil == leftView {
                leftAcessoryView.backgroundColor = .clear
                leftView = leftAcessoryView
                leftViewMode = .always
            }
        }
        updateAccessoryViewFrame()
        // Right Margin
        rightView = nil
        rightViewMode = .never
        if rightMargin > 0 {
            if nil == rightView {
                rightAcessoryView.backgroundColor = .clear
                rightView = rightAcessoryView
                rightViewMode = .always
            }
            updateAccessoryViewFrame()
        }
    }
    private func updateAccessoryViewFrame() {
        // Left View Frame
        var leftRect = bounds
        leftRect.size.width = leftMargin
        leftAcessoryView.frame = leftRect
        // Right View Frame
        var rightRect = bounds
        rightRect.size.width = rightMargin
        rightAcessoryView.frame = rightRect
    }
    // 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //2
        guard string.count > 0 else {
            return true
        }
        //3
        let currentText = textField.text ?? ""
        //4
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        //5
        return prospectiveText.count <= maxLength
    }
}
