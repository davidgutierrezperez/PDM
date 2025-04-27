//
//  FolderListViewController.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

class FolderListVC: UIViewController {
    
    private let viewModel = FolderListViewModel()
    private let tableView = FolderTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        addRightBarButton(image: UIImage(systemName: "folder.badge.plus")!, selector: #selector(openCreateFolderVC))
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("El número de carpetas es: ", viewModel.numberOfFolders())
    }
    
    @objc private func openCreateFolderVC(){
        let createFolderVC = CreateEntityVC(title: "New Folder")
        
        createFolderVC.onCreated = { [weak self] folderTitle in
            self?.viewModel.createFolder(title: folderTitle)
        }
        
        let navVC = UINavigationController(rootViewController: createFolderVC)
        present(navVC, animated: true)
    }
    
    private func setupView(){
        addChild(tableView)
        view.addSubview(tableView.view)
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                tableView.view.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            tableView.didMove(toParent: self)
    }

}
