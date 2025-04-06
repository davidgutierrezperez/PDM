//
//  FileManagerHelper.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit
import AVFoundation
import CoreData

/// Clase que controla las operaciones relacionadas con el manejo de ficheros como: guardado, carga y borrado.
class FileManagerHelper {
    
    /// Única instancia de la clase a llamar.
    static let shared = FileManagerHelper()
    
    /// Constructor privado de la clase para evitar que sea instanciada.
    private init(){}
    
    /// Permite obtener la ruta un archivo dentro del directorio */Documents* de la aplicación.
    /// - Parameter relativePath: ruta relativa del archivo.
    /// - Returns: ruta del archivo dentro del directorio */Documents* de la aplicación.
    static func getFilePath(from relativePath: String) -> URL? {
        return FileManagerHelper.getDocumentsDirectory().appendingPathComponent(relativePath)
   }
    
    /// Permite obtener la imagen asociada a una canción a partir de su rutra.
    /// - Parameter url: ruta del fichero de audio.
    /// - Returns: imagen asociada a la canción.
    static func getImageFromAudioFile(from url: URL) -> UIImage {
        let audio = AVURLAsset(url: url)
        
        for metadata in audio.commonMetadata {
            if metadata.commonKey == .commonKeyArtwork, let data = metadata.value as? Data {
                return UIImage(data: data) ?? UIImage()
            }
        }
        
        return UIImage()
    }
    
    /// Maneja las operaciones relacidas con las selección de un fichero de audio. Guarda
    /// la canción seleccionada en */Documents* y en *Core Data*.
    /// - Parameter url: ruta del fichero de audio seleccionado.
    /// - Returns: devuelve **true** si se han podido completar todas las operaciones y **false** en caso contrario.
    static func handleSelectedAudio(url: URL) -> Bool {
        guard let savedURL = FileManagerHelper.saveAudioFile(from: url) else { return false }
            
        let image = FileManagerHelper.getImageFromAudioFile(from: savedURL)
            
        saveSongToCoreData(title: savedURL.lastPathComponent, artist: "", band: "", image: image, audioPath: savedURL)
            
        return true
    }
    
    /// Devuelve la ruta del directorio */Documents* de la aplicación.
    /// - Returns: objecto *URL* con la ruta del directorio */Documents* de la aplicación.
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Comprueba si una canción ya es almacenada por la aplicación.
    /// - Parameter url: ruta del fichero de audio a comprobar.
    /// - Returns: devuelve **true** si el fichero está guardado y **false** en caso contrario.
    static func checkIfAudioFileExist(from url: URL) -> Bool {
        let fileManager = FileManager.default
        let destinationPath = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
        
        if (fileManager.fileExists(atPath: destinationPath.path)){
            return true
        }
        
        return false
    }
    
    
    /// Guarda un fichero de audio en */Documents*.
    /// - Parameter url: fichero de audio a guardar.
    /// - Returns: devuelve la ruta del fichero de audio ya guardado.
    static func saveAudioFile(from url: URL) -> URL? {
        let fileManager = FileManager.default
        let destinationPath = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: destinationPath.path) {
                try fileManager.removeItem(at: destinationPath)
            }
            
            if fileManager.isUbiquitousItem(at: url) {
                try fileManager.startDownloadingUbiquitousItem(at: url)
            }
            
            try fileManager.copyItem(at: url, to: destinationPath)
            
            print("Se ha guarado correctamente en: ", destinationPath)
            return destinationPath
            
        } catch {
            print("❌No se ha podido guardar el archivo en: ", url)
            return nil
        }

    }
    
    /// Guarda una canción en *Core Data*.
    /// - Parameters:
    ///   - title: titulo de la canción.
    ///   - artist: artista de la canción.
    ///   - band: banda de la canción.
    ///   - image: imagen asociada a la canción.
    ///   - audioPath: ruta del fichero de audio.
    static func saveSongToCoreData(title: String, artist: String, band: String, image: UIImage, audioPath: URL){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newSong = NSEntityDescription.insertNewObject(forEntityName: "SongEntity", into: context)
        let duration = getDurationFromSong(of: audioPath)
        
        newSong.setValue(title, forKey: "title")
        newSong.setValue(artist, forKey: "artist")
        newSong.setValue(band, forKey: "band")
        newSong.setValue(false, forKey: "isFavourite")
        newSong.setValue(duration, forKey: "duration")
        
        if let image = image.pngData() {
            newSong.setValue(image, forKey: "image")
        }
        
        newSong.setValue(audioPath.path, forKey: "audio")
        
        do {
            try context.save()
            print("✅Se ha podido guardar en CoreData en: \(audioPath.path)")
        } catch {
            print("❌No se ha podido guardar la canción to CoreData")
        }
    }
    
    /// Elimina una canción de la aplicación.
    /// - Parameter song: canción a eliminar.
    static func deleteSong(song: Song){
        deleteSongFromCoreData(title: song.title!)
        deleteSongFromDocuments(song: song)
    }
    
    /// Elimina una canción de */Documents*.
    /// - Parameter song: canción a eliminar.
    static func deleteSongFromDocuments(song: Song){
        guard let audioPath = song.audio else { return }
        
        let fileManager = FileManager.default
        let fileURL = FileManagerHelper.getDocumentsDirectory().appendingPathComponent(audioPath.lastPathComponent)
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("✅Se ha eliminado la canción: ", song.title!)
        } catch {
            print("❌No se ha podido eliminar la canción: ", song.title!)
        }
    }
    
    /// Elimina una canción de *Core Data*.
    /// - Parameter title: título de la canción a eliminar.
    static func deleteSongFromCoreData(title: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let songToDelete = results.first {
                context.delete(songToDelete)
                try context.save()
                print("✅Se ha podido eliminar la canción: ", title)
            }
        } catch {
            print("❌No se ha podido eliminar la cancion: ", title)
        }
    }
    
    /// Añade una canción a favoritos.
    /// - Parameter title: título de la canción.
    static func addSongToFavourites(title: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let songToFavourites = results.first {
                songToFavourites.isFavourite.toggle()
                try context.save()
                
                if (songToFavourites.isFavourite) { print("✅Se ha AÑADIDO la siguiente canción a favoritos: ", title) }
                else { print("✅Se ha ELIMINADO la siguiente canción de favoritos: ", title)}
                
            }
        } catch {
            print("❌No se ha podido añadir la siguiente canción a favoritos: ", title)
        }
    }
    
    /// Comprueba si una canción está catalogada como favorita.
    /// - Parameter title: título de la canción.
    /// - Returns: devuelve **true** si la canción está catalogad como favorita y **false**
    /// en caso contraio.
    static func isSongInFavourites(title: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let song = results.first {
                try context.save()
                return song.isFavourite
            }
        } catch {
            print("❌No se ha podido saber si la siguiente canción está en favoritos: ", title)
        }
        
        
        return false
    }
    
    /// Permite obtener todas las canciones almacenadas en *Core Data*.
    /// - Returns: un array de *Song* con todas las canciones almacenadas en *Core Data*.
    static func loadSongsFromCoreData() -> [Song] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchContext = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        
        do {
            let songs = try context.fetch(fetchContext)
            return songs.compactMap { song in
                guard let title = song.value(forKey: "title") as? String,
                      let artist = song.value(forKey: "artist") as? String,
                      let band = song.value(forKey: "band") as? String,
                      let duration = song.value(forKey: "duration") as? String else { return nil }
                
                let isFavourite = song.value(forKey: "isFavourite") as? Bool ?? false

                let imageData = song.value(forKey: "image") as? Data
                let image = imageData != nil ? UIImage(data: imageData!) : nil

                let audioPath = song.value(forKey: "audio") as? String
                let audio = audioPath != nil ? URL(fileURLWithPath: audioPath!) : nil

                return Song(title: title, artist: artist, band: band, image: image, audio: audio, isFavourite: isFavourite, duration: duration)
            }
        } catch {
            print("❌No se ha podido cargar las canciones de CoreData")
            return []
        }
    }
    
    /// Permite cargar una canción desde *Core Data*.
    /// - Parameter title: título de la canción.
    /// - Returns: la canción cargada en caso de que exista.
    static func loadSongFromCoreData(title: String) -> Song? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let song = result.first {
                guard let title = song.value(forKey: "title") as? String,
                      let artist = song.value(forKey: "artist") as? String,
                      let band = song.value(forKey: "band") as? String,
                      let duration = song.value(forKey: "duration") as? String else { return nil }
                
                let isFavourite = song.value(forKey: "isFavourite") as? Bool ?? false

                let imageData = song.value(forKey: "image") as? Data
                let image = imageData != nil ? UIImage(data: imageData!) : nil

                let audioPath = song.value(forKey: "audio") as? String
                let audio = audioPath != nil ? URL(fileURLWithPath: audioPath!) : nil

                return Song(title: title, artist: artist, band: band, image: image, audio: audio, isFavourite: isFavourite, duration: duration)
            }
        } catch {
            print("❌No se ha podido cargar la canción de CoreData")
        }
        
        return nil
    }
    
    /// Carga todas las canciones catalogadas como favoritas que estén en *Core Data*.
    /// - Returns: un array de *Song* con todas las canciones catalogadas como favoritas.
    static func loadFavouriteSongsFromCoreData() -> [Song] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
            fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        
        do {
            let songs = try context.fetch(fetchRequest)
            return songs.compactMap { song in
                guard let title = song.value(forKey: "title") as? String,
                      let artist = song.value(forKey: "artist") as? String,
                      let band = song.value(forKey: "band") as? String,
                      let duration = song.value(forKey: "duration") as? String else { return nil }
                
                let isFavourite = song.value(forKey: "isFavourite") as? Bool ?? false
                
                let imageData = song.value(forKey: "image") as? Data
                let image = imageData != nil ? UIImage(data: imageData!) : nil
                
                let audioPath = song.value(forKey: "audio") as? String
                let audio = audioPath != nil ? URL(fileURLWithPath: audioPath!) : nil
                
                return Song(title: title, artist: artist, band: band, image: image, audio: audio, isFavourite: isFavourite, duration: duration)
            }
        } catch {
            print("❌No se ha podido cargar las canciones favoritas de CoreData")
            return []
        }
    }
    
    /// Guarda una nueva *playlist* en *Core Data*.
    /// - Parameter playlist: *playlist* a guardar.
    static func savePlaylistToCoreData(playlist: Playlist){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let newPlaylist = NSEntityDescription.insertNewObject(forEntityName: "PlaylistEntity", into: context)
        
        newPlaylist.setValue(playlist.name, forKey: "name")
        newPlaylist.setValue(playlist.songs, forKey: "songs")
        
        if let image = playlist.image?.pngData() {
            newPlaylist.setValue(image, forKey: "image")
        }
        
        do {
            try context.save()
            print("✅Se ha podido guardar la nueva Playlist en CoreData")
        } catch {
            print("❌No se ha podido guardar la Playlist en CoreData")
        }
        
    }
    
    /// Carga todas las *playlists* almacenadas en *Core Data*.
    /// - Returns: array de *Playlist* con todas las *playlists* almacenadas.
    static func loadPlaylistsFromCoreData() -> [Playlist] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaylistEntity")
        
        do {
            let playlists = try context.fetch(fetchRequest)
            print("Se ha podido obtener la playlist")
            
            return playlists.compactMap { playlist in
                let playlistName = playlist.value(forKey: "name") as? String
                let imageData = playlist.value(forKey: "image") as? Data
                let image = imageData != nil ? UIImage(data: imageData!) : nil
                let songs = playlist.value(forKey: "songs") as? [Song]

                return Playlist(name: playlistName!, image: image as UIImage?, songs: songs ?? [])
            }
        } catch {
            print("ERROR AL OBTENER LAS PLAYLISTS")
        }
        
        return []
    }
    
    /// Elimina una *playlist* de *Core Data*.
    /// - Parameter playlistTitle: título de la *playlist* a eliminar.
    static func deletePlaylistFromCoreData(playlistTitle: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaylistEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", playlistTitle)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let playlistToDelete = results.first {
                context.delete(playlistToDelete)
                try context.save()
                print("✅Se ha podido eliminar la playlist: ", playlistTitle)
            } else {
                print("⚠️ No se encontró la playlist con el nombre: \(playlistTitle)")
            }
        } catch {
            print("NO SE PUEDO BORRAR LA PLAYLIST: ", playlistTitle)
        }
    }
    
    /// Añade una canción a una *playlist*.
    /// - Parameters:
    ///   - playlistTitle: título de la *playlist*.
    ///   - song: canción a añadir.
    static func addSongToPlaylist(playlistTitle: String, song: Song){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaylistEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", playlistTitle)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let playlist = results.first {
                var currentSongs = playlist.value(forKey: "songs") as? [String] ?? []
                
                if let title = song.title, !currentSongs.contains(title) {
                    currentSongs.append(title)
                }
                
                playlist.setValue(currentSongs, forKey: "songs")
                
                try context.save()
                print("✅ Canción '\(song.title ?? "")' añadida a la playlist '\(playlistTitle)'")
            } else {
                print("⚠️ Playlist no encontrada con nombre: \(playlistTitle)")
            }
        } catch {
            print("No se pudo guardar la canción \(song.title) en \(playlistTitle)")
        }
    }
    
    /// Carga todas las canciones de una determinada *playlist* desde *Core Data*.
    /// - Parameter name: nombre de la *playlist*.
    /// - Returns: array de *Song* con todas las canciones de la *playlist*.
    static func loadSongsOfPlaylistFromCoreData(name: String) -> [Song] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaylistEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let playlist = results.first {
                let songNames = playlist.value(forKey: "songs") as? [String]
                
                var songs: [Song] = []
                
                songNames?.forEach({ songTitle in
                    if let loadedSong = loadSongFromCoreData(title: songTitle) {
                        songs.append(loadedSong)
                    }
                })
                
                return songs
            }
        } catch {
            print("No se pudo obtener las canciones de la playlist: ", name)
            return []
        }
        
        return []
    }
    
    /// Elimina una canción de una determinada *playlist*.
    /// - Parameters:
    ///   - playlistTitle: título de la *playlist*.
    ///   - songTitle: título de la canción a eliminar.
    static func deleteSongOfPlaylistFromCoreData(playlistTitle: String, songTitle: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainerPlaylist.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaylistEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", playlistTitle)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let playlist = result.first {
                var currentSongs = playlist.value(forKey: "songs") as? [String] ?? []
                
                if (currentSongs.contains(songTitle)){
                    currentSongs.removeAll { $0 == songTitle }
                }
                
                playlist.setValue(currentSongs, forKey: "songs")
                
                try context.save()
            }
        } catch {
            print("No se pudo obtener las cancion de la playlist: ", playlistTitle)
        }
    }
}



