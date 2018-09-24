//
//  MessagesViewController.swift
//  Rocket.Chat
//
//  Created by Filipe Alvarenga on 19/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController
import RealmSwift
import DifferenceKit

final class MessagesViewController: RocketChatViewController {
    var subscription: Subscription!
    var heightCache: [AnyHashable: CGFloat] = [:]
    var sectionsToAddLater: [AnyChatSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(BasicMessageCell.nib, forCellWithReuseIdentifier: BasicMessageCell.identifier)

        var messageSections = Array(subscription.messages.map(Message.init).map { (message) -> AnyChatSection in
            let messageSectionModel = MessageSectionModel(message: message.unmanaged, daySeparator: nil, isLoadingMore: false, isNew: false)
            let messageSection = MessageSection(object: AnyDifferentiable(messageSectionModel))
            return AnyChatSection(messageSection)
        })

        if messageSections.count > 30 {
            for index in 1..<20 {
                sectionsToAddLater.append(messageSections[index])
                messageSections.remove(at: index)
            }
        }

        data = messageSections
        updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        data.append(contentsOf: sectionsToAddLater)
        updateData()
    }

    func openURL(url: URL) {
        WebBrowserManager.open(url: url)
    }

}

extension MessagesViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = data[indexPath.section]
        let viewModel = section.viewModels()[indexPath.row]
        if let height = heightCache[viewModel.differenceIdentifier] {
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        } else {
            let sizingCell = BasicMessageCell.sizingCell
            sizingCell.prepareForReuse()
            sizingCell.viewModel = viewModel
            sizingCell.configure()
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            let size = sizingCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            heightCache[viewModel.differenceIdentifier] = size.height
            return size
        }
    }
}

extension MessagesViewController: UserActionSheetPresenter {
    func presentActionSheetForUser(_ user: User, source: (view: UIView?, rect: CGRect?)?) {
        presentActionSheetForUser(user, subscription: subscription, source: source)
    }
}
