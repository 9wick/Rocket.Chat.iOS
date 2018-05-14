//
//  MessageTextCacheManager.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 02/05/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation

final class MessageTextCacheManager {

    static let shared = MessageTextCacheManager()
    let cache = NSCache<NSString, NSAttributedString>()

    internal func cachedKey(for identifier: String) -> NSString {
        return NSString(string: "\(identifier)-cachedattrstring")
    }

    internal func cachedSimplifiedKey(for identifier: String) -> NSString {
        return NSString(string: "\(identifier)-cachedsimplifiedattrstring")
    }

    func clear() {
        cache.removeAllObjects()
    }

    func remove(for message: Message) {
        guard let identifier = message.identifier else { return }
        cache.removeObject(forKey: cachedKey(for: identifier))
    }

    @discardableResult func update(for message: Message) -> NSMutableAttributedString? {
        guard let identifier = message.identifier else { return nil }

        let key = cachedKey(for: identifier)

        let text = NSMutableAttributedString(attributedString:
            NSAttributedString(string: message.textNormalized()).applyingCustomEmojis(CustomEmoji.emojiStrings)
        )

        if message.isSystemMessage() {
            text.setFont(MessageTextFontAttributes.italicFont)
            text.setFontColor(MessageTextFontAttributes.systemFontColor)
        } else {
            text.setFont(MessageTextFontAttributes.defaultFont)
            text.setFontColor(MessageTextFontAttributes.defaultFontColor)
            text.setLineSpacing(MessageTextFontAttributes.defaultFont)
        }

        let mentions = Array(message.mentions.compactMap { $0.username })
        let channels = Array(message.channels.compactMap { $0.name })
        let username = AuthManager.currentUser()?.username

        let attributedString = text.transformMarkdown()
        let finalText = NSMutableAttributedString(attributedString: attributedString)
        finalText.trimCharacters(in: .whitespaces)
        finalText.highlightMentions(mentions, username: username)
        finalText.highlightChannels(channels)

        cache.setObject(finalText, forKey: key)
        return finalText
    }

    @discardableResult func updateSimplified(for message: Message) -> NSMutableAttributedString? {
        guard let identifier = message.identifier else { return nil }

        let key = cachedSimplifiedKey(for: identifier)

        let text = NSMutableAttributedString(attributedString:
            NSAttributedString(string: message.textNormalized())
        )

        if !message.isSystemMessage() {
            text.setLineSpacing(MessageTextFontAttributes.defaultFont)
        }

        let attributedString = text.transformMarkdown()
        let finalText = NSMutableAttributedString(attributedString: attributedString)
        finalText.trimCharacters(in: .whitespaces)

        cache.setObject(finalText, forKey: key)
        return finalText
    }

    func messageSimplified(for message: Message) -> NSMutableAttributedString? {
        guard let identifier = message.identifier else { return nil }

        var resultText: NSAttributedString?
        let key = cachedSimplifiedKey(for: identifier)

        if let cachedVersion = cache.object(forKey: key) {
            resultText = cachedVersion
        } else if let result = updateSimplified(for: message) {
            resultText = result
        }

        if let resultText = resultText {
            return NSMutableAttributedString(attributedString: resultText)
        }

        return nil
    }

    func message(for message: Message) -> NSMutableAttributedString? {
        guard let identifier = message.identifier else { return nil }

        var resultText: NSAttributedString?
        let key = cachedKey(for: identifier)

        if let cachedVersion = cache.object(forKey: key) {
            resultText = cachedVersion
        } else if let result = update(for: message) {
            resultText = result
        }

        if let resultText = resultText {
            return NSMutableAttributedString(attributedString: resultText)
        }

        return nil
    }

}
