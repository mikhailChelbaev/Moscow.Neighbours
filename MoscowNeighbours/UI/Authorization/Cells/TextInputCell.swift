//
//  TextInputCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.12.2021.
//

import UIKit

final class TextInputCell: CellView {
    
    typealias TextCompletion = (String) -> Void
    
    enum Layout {
        static let textFieldContainerHeight: CGFloat = 46
    }
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        return tf
    }()
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .grayBackground
        view.layer.cornerRadius = Layout.textFieldContainerHeight / 2
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var textDidChange: TextCompletion?
    
    override func setUpView() {
        addSubview(headerLabel)
        headerLabel.stickToSuperviewEdges([.left, .top, .right],
                                          insets: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        addSubview(textFieldContainer)
        textFieldContainer.stickToSuperviewEdges([.left, .right, .bottom],
                                                 insets: .init(top: 0, left: 20, bottom: 15, right: 20))
        textFieldContainer.top(7, to: headerLabel)
        textFieldContainer.height(Layout.textFieldContainerHeight)
        
        textFieldContainer.addSubview(textField)
        textField.stickToSuperviewEdges(.all,
                                        insets: .init(top: 5, left: 15, bottom: 5, right: 15))
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func update(headerText: String,
                placeholder: String,
                keyboardType: UIKeyboardType = .default,
                textContentType: UITextContentType?,
                textDidChange: TextCompletion?) {
        headerLabel.text = headerText
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.textContentType = textContentType
        self.textDidChange = textDidChange
    }
    
    @objc private func textChanged() {
        textDidChange?(textField.text ?? "")
    }
    
}

