//
//  ViewControllerExt.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        print(selectedFileURL)
    }
}
