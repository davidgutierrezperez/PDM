//
//  PlaylistCreationVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

/// Controlador que permite la creación de una nueva *playlist*.
class PlaylistCreationVC: PlaylistCreationView {
    
    /// Closoure que permite acceder a las funciones de la clase desde
    /// una vista padre.
    var onPlaylistCreated: (() -> Void)?

    /// Eventos a ocurrir cuando la vista carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerButton.addTarget(self, action: #selector(pickImageForPlaylist), for: .touchUpInside)
    }
    
    /// Configura los botones de la vista y establece sus funciones asociadas.
    override func configureButtons(){
        super.configureButtons()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = okButton
        
        addTargetToButton(boton: okButton, target: self, action: #selector(createPlaylist))
        addTargetToButton(boton: cancelButton, target: self, action: #selector(dismissVC))
        
        okButton.isEnabled = false
    }
    
    /// Configura el texto para la entrada del nombre de la nueva *playlist*.
    override func configureTextfield(){
        super.configureTextfield()
        
        textfield.addTarget(self, action: #selector(checkIfTextfieldIsEmpty), for: .allEditingEvents)
    }
    
    
    /// Permite añadir un *target* a un botón y asociarle una función a ejecutar cuando este es pulsado.
    /// - Parameters:
    ///   - boton: boton a configurar.
    ///   - target: vista desde la que se pulsará el botón.
    ///   - action: funicón a ejecutar cuando se pulse el botón.
    private func addTargetToButton(boton: UIBarButtonItem, target: AnyObject?, action: Selector) {
        boton.target = target
        boton.action = action
    }
    
    /// Permite crear una nueva *playlist* y guardarla en *Core Data*.
    @objc private func createPlaylist(){
        FileManagerHelper.savePlaylistToCoreData(playlist: Playlist(name: textfield.text!, image: playlistImage.image))
        
        onPlaylistCreated?()
        dismiss(animated: true)
    }
    
    /// Oculta la vista.
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    /// Comprueba si se ha introducido un nombre para la nueva *playlist*.
    @objc private func checkIfTextfieldIsEmpty(){
        okButton.isEnabled = (!textfield.text!.isEmpty)
    }
    
    /// Permite seleccionar una imagen para la nueva *playlist*.
    @objc private func pickImageForPlaylist(){
        let imagePicker = UIDocumentPickerViewController(forOpeningContentTypes: [.png, .jpeg])
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }

}

extension PlaylistCreationVC: UIDocumentPickerDelegate {
    
    /// Permite escoger una archivo de imagen.
    /// - Parameters:
    ///   - controller: vista desde la que se mostrará el controlador para la selección de archivos.
    ///   - urls: archivos seleccionados.
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedImage = urls.first else { return }
        
        if (selectedImage.startAccessingSecurityScopedResource()){
            defer {
                selectedImage.stopAccessingSecurityScopedResource()
            }
            
            do {
                let imageData = try Data(contentsOf: selectedImage)
                if let image = UIImage(data: imageData){
                    playlistImage.image = image
                }
            } catch {
                print("❌ No se pudo cargar la imagen: \(selectedImage.lastPathComponent) ")
            }
        }
    }
}
