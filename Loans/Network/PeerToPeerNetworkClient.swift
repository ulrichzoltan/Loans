//
//  PeerToPeerNetworkClient.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerToPeerNetworkClient: NSObject {

    static let serviceType = "loans-service";
    let localPeerID: MCPeerID
    let advertiser: MCNearbyServiceAdvertiser

    init(withUser user: User) {

        localPeerID = MCPeerID(displayName: user.id)
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: "loans-service")

        super.init()

        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
}

extension PeerToPeerNetworkClient: MCNearbyServiceAdvertiserDelegate {

    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {

        print("Did receive invitation from: \(peerID.displayName)")
    }


    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {

        print("Failed to advertise with error: \(error)")
    }
}
