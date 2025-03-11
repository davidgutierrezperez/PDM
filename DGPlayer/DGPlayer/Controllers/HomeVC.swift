//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class HomeVC: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let songs: [Song] = [
        Song(title: "Creature Comfort", artist: "nil", band: "Arcade Fire", image: UIImage(named: "cover1")),
        Song(title: "Welcome to Your Life", artist: "nil", band: "Grouplove", image: UIImage(named: "cover2")),
        Song(title: "Ophelia", artist: "nil", band: "The Lumineers", image: UIImage(named: "cover3")),
        Song(title: "Electric Feel", artist: "nil", band: "MGMT", image: UIImage(named: "cover4")),
        Song(title: "Why Won't You Make Up Your Mind?", artist: "nil", band: "Tame Impala", image: UIImage(named: "cover5")),
        Song(title: "Lonely Boy", artist: "nil", band: "The Black Keys", image: UIImage(named: "cover6"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = configureAddButton()
        configureCollectionView()
    }
    
    private func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTupped))
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: view.frame.width - 20, height: 60)
                layout.minimumLineSpacing = 10

                collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.dataSource = self
                collectionView.delegate = self
        collectionView.register(DGSongCell.self, forCellWithReuseIdentifier: DGSongCell.reusableIdentifier)

                view.addSubview(collectionView)
                collectionView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }
    
    @objc func buttonTupped(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        
        present(documentPicker, animated: true)
    }
    
    
}

extension HomeVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        
        print(selectedFile.lastPathComponent)
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DGSongCell.reusableIdentifier, for: indexPath) as! DGSongCell
        let song = songs[indexPath.item]
        cell.configure(song:song)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
}
