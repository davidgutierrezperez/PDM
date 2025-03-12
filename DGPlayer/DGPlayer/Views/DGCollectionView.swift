//
//  DGCollectionView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class DGCollectionView: UICollectionViewController {
    
    private var songs : [Song] = []

    
    init(songs: [Song]){
        self.songs = songs
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 60)
        layout.minimumLineSpacing = 10
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(DGSongCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func setSongs(songs: [Song]){
        self.songs = songs
        collectionView.reloadData()
    }
    
    func addSong(song: Song){
        self.songs.append(song)
        collectionView.reloadData()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return songs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DGSongCell
        let song = songs[indexPath.item]
        cell.configure(song: song)
    
        return cell
    }
    


}
