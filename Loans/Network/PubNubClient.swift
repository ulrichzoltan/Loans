//
//  PubNubClient.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation
import PubNub


class PubNubClient: NSObject, NetworkClient {

    let pubNub: PubNub
    let channel: String
    var remoteChannel: String? = nil
    weak var delegate: NetworkClientDelegate? = nil

    required init(withUser user: User) {

        let configuration = PNConfiguration(publishKey: "pub-c-c679c7c3-4bfd-44e9-9a1c-d9f4290be09f",
                                            subscribeKey: "sub-c-4df47f2a-6ac1-11e6-80e7-02ee2ddab7fe")
        pubNub = PubNub.clientWithConfiguration(configuration)
        self.channel = user.id

        super.init()

        pubNub.addListener(self)
    }

    func openConnection(to: String, completion: ((error: NSError?) -> ())?) {

        remoteChannel = to
        pubNub.subscribeToChannels([to], withPresence: true)
    }

    func closeConnection(to: String) {

        pubNub.unsubscribeFromChannels([to], withPresence: true)
        remoteChannel = nil
    }

    func sendMessage(message: NSData, to destinationID: String, completion: (error: NSError?) -> ()) {

        pubNub.publish(message, toChannel: destinationID, compressed: true) { status in

            if status.error {
                completion(error: NSError(domain: "PubNub", code: 0, userInfo: [:]))
            } else {
                completion(error: nil)
            }
        }
    }

    func setDelegate(delegate: NetworkClientDelegate) {

        self.delegate = delegate
    }

    func registerPushToken(token: NSData) {

        pubNub.addPushNotificationsOnChannels(
            [channel],
            withDevicePushToken: token,
            andCompletion: { status in

            if !status.error {

                // Handle successful push notification enabling on passed channels.
            }
            else {

                /**
                 Handle modification error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 
                 Request can be resent using: [status retry];
                 */
            }
        })
    }
}

extension PubNubClient: PNObjectEventListener {

    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {

        if let data = message.data.message as? NSData {
            self.delegate?.didReceive(data, from: channel)
        }
    }

    // New presence event handling.
    func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {

        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.actualChannel != nil {

            // Presence event has been received on channel group stored in event.data.subscribedChannel.
        }
        else {

            // Presence event has been received on channel stored in event.data.subscribedChannel.
        }

        if event.data.presenceEvent != "state-change" {

            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {

            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
                "\(event.data.presence.state)");
        }
    }

    // Handle subscription status change.
    func client(client: PubNub, didReceiveStatus status: PNStatus) {

        if status.operation == .SubscribeOperation {

            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {

                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {

                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                }
                else {

                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {

                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {

                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {

                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {

                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
}
