//
//  FileManagerHelper.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit
import AVFoundation
import CoreData

class FileManagerHelper {
    static let shared = FileManagerHelper()
    
    private init(){}
    
    static func getImageFromAudioFile(from url: URL) -> UIImage {
        let audio = AVURLAsset(url: url)
        
        for metadata in audio.commonMetadata {
            if metadata.commonKey == .commonKeyArtwork, let data = metadata.value as? Data {
                return UIImage(data: data) ?? UIImage()
            }
        }
        
        return UIImage()
    }
    
    static func handleSelectedAudio(url: URL) -> Bool {
        if (!checkIfAudioFileExist(from: url)){
            guard let savedURL = FileManagerHelper.saveAudioFile(from: url) else { return false }
            
            let image = FileManagerHelper.getImageFromAudioFile(from: savedURL)
            
            saveSongToCoreData(title: savedURL.lastPathComponent, artist: "", band: "", image: image, audioPath: savedURL)
            
            return true
        }
        
        return false
    }

    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func checkIfAudioFileExist(from url: URL) -> Bool {
        let fileManager = FileManager.default
        let destinationPath = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
        
        if (fileManager.fileExists(atPath: destinationPath.path)){
            return true
        }
        
        return false
    }
    

    static func saveAudioFile(from url: URL) -> URL? {
        let fileManager = FileManager.default
        let destinationPath = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: destinationPath.path) {
                try fileManager.removeItem(at: destinationPath)
            }
            
            try fileManager.copyItem(at: url, to: destinationPath)
            
            return destinationPath
        } catch {
            print("No se ha podido guardar el archivo en: ", url)
            return nil
        }
        
    }
    
    static func saveSongToCoreData(title: String, artist: String, band: String, image: UIImage, audioPath: URL){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newSong = NSEntityDescription.insertNewObject(forEntityName: "SongEntity", into: context)
        
        newSong.setValue(title, forKey: "title")
        newSong.setValue(artist, forKey: "artist")
        newSong.setValue(band, forKey: "band")
        
        if let image = image.pngData() {
            newSong.setValue(image, forKey: "image")
        }
        
        newSong.setValue(audioPath.path, forKey: "audio")
        
        do {
            try context.save()
            print("✅Se ha podido guardar en CoreData en: \(audioPath.path)")
        } catch {
            print("No se ha podido guardar la canción to CoreData")
        }
    }
    
    static func loadSongsFromCoreData() -> [Song] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchContext = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        
        do {
            let songs = try context.fetch(fetchContext)
            return songs.compactMap { song in
                guard let title = song.value(forKey: "title") as? String,
                let artist = song.value(forKey: "artist") as? String,
                let band = song.value(forKey: "band") as? String else { return nil }

                let imageData = song.value(forKey: "image") as? Data
                let image = imageData != nil ? UIImage(data: imageData!) : nil

                let audioPath = song.value(forKey: "audio") as? String
                let audio = audioPath != nil ? URL(fileURLWithPath: audioPath!) : nil

                return Song(title: title, artist: artist, band: band, image: image, audio: audio)
            }
        } catch {
            print("No se ha podido cargar las canciones de CoreData")
            return []
        }
    }
}



