//
//  SongPlayerFooterVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 1/4/25.
//

import UIKit


/// Controlador que muestra en la mayoría de vistas
/// la canción actual que se está reproduciendo y permite acceder
/// a su reproductor.
class SongPlayerFooterVC: UIViewController {
    
    /// Única instancia de la clase SongPlayerFooterVC
    static let shared = SongPlayerFooterVC()
    
    
    /// Interfaz de SongPlayerFooter. Representa la vista
    private let footerView = SongPlayerFooterUI()
    
    
    /// Construtor privado que evita que la clase pueda ser instanciada.
    /// Añade **footerView** como vista y la configura
    private init(){
        super.init(nibName: nil, bundle: nil)
        view.addSubview(footerView)
                
        setFooterViewAsView()
    }
    
    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Eventos a producir cuando la  vista se cargue nuevamente.
    /// - Parameter animated: indica si se debe animar la aparición de la vista.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let playPauseIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        footerView.changePlaySongIcon(systemName: playPauseIcon)
    }
    
    
    /// Configura la interfaz del controlador y añade **footerView** como vista.
    private func setFooterViewAsView(){
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: view.topAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        footerView.playIcon.addTarget(self, action: #selector(playPauseSongPlayer), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPlayer))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    /// Actualiza la vista con nueva canción.
    /// - Parameter song: canción con la que se debe actualizar la vista
    func updateView(with song: Song){
        footerView.updateView(with: song)
    }
    
    
    /// Muestra la vista en un controlador padre. En este caso, será el TabBar.
    /// - Parameter parent: controlador padre al que se añade **SongPlayerFooterVC**.
    func show(in parent: UIViewController) {
        guard view.superview == nil else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.view.addSubview(view)

        if let tabBar = (parent as? UITabBarController)?.tabBar {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
                view.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor),
                view.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }

    
    /// Configura la visibilidad de la vista.
    /// - Parameter value: valor de la visibilidad de la vista.
    func setAlpha(value: CGFloat){
        view.alpha = value
    }

    
    /// Esconde la vista y la elimina del padre como subvista.
    func hide() {
        setAlpha(value: 0)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
    /// Reproduce o pause la canción en función de su estado.
    @objc private func playPauseSongPlayer(){
        guard let player = SongPlayerManager.shared.player else { return }
        
        if (player.isPlaying){
            player.pause()
            footerView.changePlaySongIcon(systemName: DGSongControl.playIcon)
        } else {
            player.play()
            footerView.changePlaySongIcon(systemName: DGSongControl.pauseIcon)
        }
    }
    
    
    /// Muestra el reproductor de la canción cuando se pulsa la vista del controlador.
    @objc private func openPlayer() {
        guard let topVC = UIApplication.topMostViewController() else {
            return
        }

        let song = SongPlayerManager.shared.song!
        let songs = SongPlayerManager.shared.songs
        let index = SongPlayerManager.shared.selectedIndex

        SongPlayerVC.present(from: topVC, with: song, songs: songs, selectedSong: index)
    }

}

extension SongPlayerFooterVC: UIGestureRecognizerDelegate {
    
    /// Reconoce un gesto sobre la vista del controlador.
    /// - Parameters:
    ///   - gestureRecognizer: objecto que reconoce los gestos llevados a cabo sobre la vista del controlador.
    ///   - touch: acción o *toque* llevado a cabo sobre la vista del controlador.
    /// - Returns: devuelve **true** si el gesto se lleva a cabo sobre cualquier elemento que no sea un botón y **false** en caso contrario.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }

        return true
    }

}


