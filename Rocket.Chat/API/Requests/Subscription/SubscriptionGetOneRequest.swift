//
//  SubscriptionGetOneRequest.swift
//  Rocket.Chat
//
//  Created by Artur Rymarz on 14.04.2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import SwiftyJSON

typealias SubscriptionGetOneResult = APIResult<SubscriptionGetOneRequest>

class SubscriptionGetOneRequest: APIRequest {
    let path = "/api/v1/subscriptions.getOne"

    let query: String?

    let roomId: String?

    init(roomId: String) {
        self.roomId = roomId
        self.query = "roomId=\(roomId)"
    }
}

extension APIResult where T == SubscriptionGetOneRequest {
    var subscription: Subscription? {
        guard let raw = raw?["subscription"] else { return nil }

        let subscription = Subscription()
        subscription.map(raw, realm: nil)
        return subscription
    }
}
