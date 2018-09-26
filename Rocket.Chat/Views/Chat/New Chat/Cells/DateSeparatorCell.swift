//
//  DateSeparatorCell.swift
//  Rocket.Chat
//
//  Created by Rafael Streit on 26/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

final class DateSeparatorCell: UICollectionViewCell, ChatCell {
    static let identifier = String(describing: DateSeparatorCell.self)

    static let sizingCell: DateSeparatorCell = {
        guard let cell = DateSeparatorCell.instantiateFromNib() else {
            return DateSeparatorCell()
        }

        return cell
    }()

    @IBOutlet weak var date: UILabel!

    var viewModel: AnyChatItem?
    var contentViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        contentViewWidthConstraint.isActive = true
    }

    func configure() {
        guard let viewModel = viewModel?.base as? DateSeparatorChatItem else {
            return
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: viewModel.date)
        if let newDate = calendar.date(from: components) {
            date.text = RCDateFormatter.date(newDate)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        date.text = ""
    }
}

extension DateSeparatorCell {

    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
        date.textColor = theme.auxiliaryText
    }

}
