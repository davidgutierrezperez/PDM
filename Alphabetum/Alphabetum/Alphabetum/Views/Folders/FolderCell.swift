//
//  FolderCell.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

protocol FolderCellDelegate: AnyObject {
    func folderCellRequestMenu(for cell: FolderCell) -> UIMenu
}

class FolderCell: UITableViewCell {
    
    static let reusableIdentifier = "FolderCell"
    
    private let title = UILabel()
    private var icon = UIImageView()
    private var numberOfNotes: Int = 0
    
    weak var delegate: FolderCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureIcon()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, numberOfNotes: Int = 0){
        configureTitle()
        
        self.title.text = title
        self.numberOfNotes = numberOfNotes
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    private func configureIcon(){
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        icon = UIImageView(image: UIImage(systemName: "folder", withConfiguration: imageConfiguration))
        
        icon.tintColor = .systemYellow
    }
    
    private func configureTitle(){
        title.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func setupView(){
        contentView.addSubview(title)
        contentView.addSubview(icon)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGray3
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24), // Ancho del icono
            icon.heightAnchor.constraint(equalToConstant: 24), // Alto del icono

            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}

extension FolderCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.delegate?.folderCellRequestMenu(for: self)
        }
    }
    
    
}
