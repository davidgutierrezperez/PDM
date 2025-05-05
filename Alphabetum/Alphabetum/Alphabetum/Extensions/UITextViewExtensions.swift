//
//  UITextViewExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

extension UITextView {
    func insertImage(_ image: UIImage){
        let resizedImage = image.resize(maxWidth: self.frame.width - 40)
        let attachment = NSTextAttachment()
        attachment.image = resizedImage
        
        let imageAttrString = NSAttributedString(attachment: attachment)
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        let selectedRange = self.selectedRange
        mutableStr.insert(imageAttrString, at: selectedRange.location)
        
        mutableStr.insert(NSAttributedString(string: "\n"), at: selectedRange.location + 1)
        
        self.attributedText = mutableStr
        self.selectedRange = NSRange(location: selectedRange.location + 2, length: 0)
    }
}
