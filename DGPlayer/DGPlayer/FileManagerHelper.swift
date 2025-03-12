//
//  FileManagerHelper.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit
import AVFoundation

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
    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func saveAudioFile(from url: URL) -> URL? {
        let fileManager = FileManager.default
        let fileDestinationPath = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: fileDestinationPath.path){
                try fileManager.removeItem(atPath: fileDestinationPath.path)
            }
            
            try fileManager.copyItem(at: url, to: fileDestinationPath)
            print("Archivo guardado en \(fileDestinationPath.path)")
            
            return fileDestinationPath
        } catch {
            print("No se pudo guardar el archivo")
        }
        
        return nil
    }

    
}
