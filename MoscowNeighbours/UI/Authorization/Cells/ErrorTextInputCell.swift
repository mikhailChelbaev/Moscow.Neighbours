//
//  ErrorTextInputCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 15.01.2022.
//

import UIKit

class ErrorTextInputCell: TextInputCell {
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 12, weight: .regular)
        label.textColor = .projectRed
        label.numberOfLines = 0
        return label
    }()
    
    override func configureView() {
        addSubview(headerLabel)
        headerLabel.pinToSuperviewEdges([.left, .top, .right],
                                        insets: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        addSubview(textFieldContainer)
        textFieldContainer.pinToSuperviewEdges([.left, .right],
                                               insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        textFieldContainer.top(7, to: headerLabel)
        textFieldContainer.height(Layout.textFieldContainerHeight)
        
        textFieldContainer.addSubview(textField)
        textField.pinToSuperviewEdges(.all,
                                      insets: .init(top: 5, left: 15, bottom: 5, right: 15))
        
        addSubview(errorLabel)
        errorLabel.top(7, to: textFieldContainer)
        errorLabel.pinToSuperviewEdges([.left, .right, .bottom],
                                       insets: .init(top: 0, left: 20, bottom: 15, right: 20))
    }
    
    func update(headerText: String,
                text: String,
                placeholder: String,
                keyboardType: UIKeyboardType,
                textContentType: UITextContentType?,
                isSecureTextEntry: Bool,
                error: String,
                textDidChange: TextCompletion?) {
        super.update(headerText: headerText, text: text, placeholder: placeholder, keyboardType: keyboardType, textContentType: textContentType, isSecureTextEntry: isSecureTextEntry, textDidChange: textDidChange)
        
        errorLabel.text = error
    }
    
}


