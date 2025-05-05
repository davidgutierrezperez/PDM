//
//  NoteCell.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import UIKit

protocol NoteCellDelegate: AnyObject {
    func noteCellRequestMenu(for cell: NoteCell) -> UIMenu
    func makePreviewViewController(for cell: NoteCell) -> NoteVC
}

class NoteCell: UITableViewCell {
    
    static let reuseIdentifier = "NoteCell"
    
    private let title = UILabel()
    private let selectionButton = UIButton()
    
    weak var delegate: NoteCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.text = "Sin título"
        
        configureSelectionButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectionUI(isVisible: Bool, isSelected: Bool){
        selectionButton.isHidden = !isVisible
        let imageButton = (isSelected) ? "checkmark.circle.fill" : "circle"
        selectionButton.setImage(UIImage(systemName: imageButton), for: .normal)
    }
    
    func configure(title: String){
        self.title.text = title
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
    
    private func setupView() {
        contentView.addSubview(selectionButton)
        contentView.addSubview(title)

        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionButton.widthAnchor.constraint(equalToConstant: 24),
            selectionButton.heightAnchor.constraint(equalToConstant: 24),

            title.leadingAnchor.constraint(equalTo: selectionButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureSelectionButton(){
        selectionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        selectionButton.tintColor = .systemBlue
        selectionButton.isHidden = true
    }

}

extension NoteCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return self.delegate?.makePreviewViewController(for: self)
        }, actionProvider: { _ in
            return self.delegate?.noteCellRequestMenu(for: self)
        })
    }
    
    
}
