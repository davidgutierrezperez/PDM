//
//  PlaylistCreationVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

class PlaylistCreationVC: PlaylistCreationView {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerButton.addTarget(self, action: #selector(pickImageForPlaylist), for: .touchUpInside)
    }
    
    
    
    override func configureButtons(){
        super.configureButtons()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = okButton
        
        addTargetToButton(boton: okButton, target: self, action: #selector(createPlaylist))
        addTargetToButton(boton: cancelButton, target: self, action: #selector(dismissVC))
        
        okButton.isEnabled = false
    }
    
    override func configureTextfield(){
        super.configureTextfield()
        
        textfield.addTarget(self, action: #selector(checkIfTextfieldIsEmpty), for: .allEditingEvents)
    }
    
    private func addTargetToButton(boton: UIBarButtonItem, target: AnyObject?, action: Selector) {
        boton.target = target
        boton.action = action
    }
    
    @objc private func createPlaylist(){
        
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    @objc private func checkIfTextfieldIsEmpty(){
        okButton.isEnabled = (!textfield.text!.isEmpty)
    }
    
    @objc private func pickImageForPlaylist(){
        let imagePicker = UIDocumentPickerViewController(forOpeningContentTypes: [.png, .jpeg])
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
        
    }

}

extension PlaylistCreationVC: UIDocumentPickerDelegate {
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
