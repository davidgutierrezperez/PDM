//
//  TextFormattingOptionsView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextFormattingOptionsView: UIView {
    
    private let formattingTextButton = UIButton()
    private let insertImageButton = UIButton()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
        
        configureButtons()
        configureStackView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        
        formattingTextButton.setImage(UIImage(systemName: "textformat", withConfiguration: buttonConfig), for: .normal)
        insertImageButton.setImage(UIImage(systemName: "paperclip", withConfiguration: buttonConfig), for: .normal)
        
        formattingTextButton.tintColor = .systemYellow
        insertImageButton.tintColor = .systemYellow
    }
    
    private func configureStackView(){
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(formattingTextButton)
        stackView.addArrangedSubview(insertImageButton)
    }
    
    private func setupView(){
        addSubview(stackView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
