//
//  ChatMessageDaySeparator.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 19/12/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

final class ChatMessageDaySeparator: UICollectionViewCell {
    static let minimumHeight = CGFloat(40)
    static let identifier = "ChatMessageDaySeparator"

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var seperatorLine: UIView!
}

extension ChatMessageDaySeparator {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
        seperatorLine.backgroundColor = theme.mutedAccent
    }
}
