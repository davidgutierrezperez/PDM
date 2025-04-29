//
//  CreateEntityVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import UIKit

enum PresentationStyle {
    case modal
    case pushed
}

class CreateEntityVC: UIViewController {
    
    private let viewModel = CreateEntityViewModel()
    private var presentationStyle: PresentationStyle
    
    var textfield = UITextField()
    var onCreated: ((String) -> Void)?
    
    init(title: String, style: PresentationStyle){
        presentationStyle = style
        
        super.init(nibName: nil, bundle: nil)
        
        textfield = createConfiguratedTextfield(placeholder: "Title of your new folder")
        
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        addCancelBarButton()
        addOkBarButton()
        
        setupView()
        
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func didTapOk() {
        guard viewModel.isValid else { return }
        onCreated?(viewModel.text)
        dismissVC()
    }
    
    override func didTapCancel() {
        dismissVC()
    }
    
    override func dismissVC(){
        if presentationStyle == .pushed {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
                            
    @objc private func textFieldDidChange(_ textfield: UITextField){
        viewModel.updateText(textfield.text!)
    }
    
    private func setupView(){
        view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createConfiguratedTextfield(placeholder: String) -> UITextField {
        let textfield = UITextField()
        
        textfield.placeholder = placeholder
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
        textfield.layer.borderColor = UIColor.white.cgColor
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width: 10, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }

    

}

extension CreateEntityVC: UITextFieldDelegate {
    override class func didChangeValue(forKey key: String) {
        
    }
}
