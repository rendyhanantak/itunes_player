//
//  EmptyTableViewCell.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(keyword: String) {
        let fullText = "No result found for \"\(keyword)\"."
        let attributedString = NSMutableAttributedString(string: fullText)

        let boldText = "\"\(keyword)\""
        let range = (fullText as NSString).range(of: boldText)

        let boldFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        attributedString.addAttribute(.font, value: boldFont, range: range)

        messageLabel.attributedText = attributedString
    }
    
}
