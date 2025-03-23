//
//  PlaylistCreationVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

class PlaylistCreationVC: PlaylistCreationView {
    
    private var selectImageButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
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

}
