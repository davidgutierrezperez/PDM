//
//  ActivityDetailOptionButton.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailOptionButton: UIButton {
    
    let detailOption: ActivityDetailOptions
    
    private var isUnderline = false
    
    init(detail: ActivityDetailOptions){
        detailOption = detail
        
        super.init(frame: CGRect())
        
        setTitleColor(AppColors.statisticOptionLabel, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleUnderline(){
        isUnderline.toggle()
        underlineTitle(isUnderline)
    }
    
    private func underlineTitle(_ underline: Bool){
        guard let title = self.title(for: .normal) else { return }
        
        let attributes: [NSAttributedString.Key: Any] = underline
            ? [.underlineStyle: NSUnderlineStyle.single.rawValue,
               .foregroundColor: UIColor.white]
            : [.foregroundColor: AppColors.statisticOptionLabel]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
