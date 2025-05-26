//
//  CreateEntityVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import UIKit

/// Enumerado que representa la forma en la que se presenta una vista.
enum PresentationStyle {
    case modal
    case pushed
}

/// Clase que representa la vista que permite crear una entidad.
final class CreateEntityVC: UIViewController {
    
    /// Objeto que maneja la información relacionada con la creación de una entidad.
    private let viewModel = CreateEntityViewModel()
    
    /// Indica el tipo de presentación de la vista.
    private var presentationStyle: PresentationStyle
    
    /// Campo de texto en el que se inserta el nombre de la entidad.
    var textfield = UITextField()
    
    /// Indica si la entidad ha sido creada y su nombre
    var onCreated: ((String) -> Void)?
    
    /// Constructor por defecto de la clase. Configura la vista.
    /// - Parameters:
    ///   - title: título de la vista.
    ///   - style: estilo de presentación.
    init(title: String, style: PresentationStyle){
        presentationStyle = style
        
        super.init(nibName: nil, bundle: nil)
        
        textfield = createConfiguratedTextfield(placeholder: "Title of your new folder")
        
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuando la vista carga por primera vez. Configura la vista y botones.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        addCancelBarButton()
        addOkBarButton()
        
        setupView()
        
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Evento que gestiona la creación de la vista.
    @objc override func didTapOk() {
        guard viewModel.isValid else { return }
        onCreated?(viewModel.text)
        dismissVC()
    }
    
    /// Evento que gestiona la cancelación de la creación de la entidad.
    @objc override func didTapCancel() {
        dismissVC()
    }
    
    /// Hace desaparecer la vista.
    override func dismissVC(){
        closeSelf(animated: true)
    }
    
    /// Evento que gestiona el cambio de contenido en el campo de texto.
    /// - Parameter textfield: campo de texto.
    @objc private func textFieldDidChange(_ textfield: UITextField){
        viewModel.updateText(textfield.text!)
    }
    
    /// Configura el layout de la vista.
    private func setupView(){
        view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    /// Configura el campo de texto de la vista.
    /// - Parameter placeholder: texto a mostrar en el campo de texto.
    /// - Returns: un objeto de tipo UITextField ya configurado.
    private func createConfiguratedTextfield(placeholder: String) -> UITextField {
        let textfield = UITextField()
        
        textfield.placeholder = placeholder
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
        textfield.layer.borderColor = UIColor.gray.cgColor
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width: 0, height: textfield.frame.height + 20))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }

    

}

extension CreateEntityVC: UITextFieldDelegate {
    override class func didChangeValue(forKey key: String) {
        
    }
}
