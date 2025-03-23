//
//  DGSongImagePlayer.swift
//  DGPlayer
//
//  Created by David Gutierrez on 22/3/25.
//

import UIKit

class DGSongImagePlayer: UIViewController {

    private var imageSong: UIImageView!
    private var backgroundImage: UIImageView!
    private var activateBackground: Bool = true
    
    init(imageSong: UIImage, activateBackground: Bool){
        super.init(nibName: nil, bundle: nil)
        
        self.imageSong = UIImageView(image: imageSong)
        self.backgroundImage = createBackgroundImage()
        self.activateBackground = activateBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBackgroundImage() -> UIImageView {
        let backgroundImage = UIImageView()
        
        backgroundImage.backgroundColor = (activateBackground) ? .black : nil
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        
        return backgroundImage
    }
    
    func updateImage(image: UIImage, activateBackground: Bool){
        imageSong.image = image
        self.activateBackground = activateBackground
        
        backgroundImage.backgroundColor = (activateBackground) ? .black : nil
    }
    
    private func configure(){
        view.addSubview(backgroundImage)
        view.addSubview(imageSong)
        
        imageSong.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        imageSong.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    
            imageSong.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSong.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageSong.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageSong.heightAnchor.constraint(equalTo: imageSong.widthAnchor) // cuadrada
        ])
    }
    
}
