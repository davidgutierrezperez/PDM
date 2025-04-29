//
//  NoteCell.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let reuseIdentifier = "NoteCell"
    
    private let title = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupView(){
        contentView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
