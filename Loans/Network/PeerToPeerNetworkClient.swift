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
    let browser: MCNearbyServiceBrowser

    var currentSession: MCSession

    var availablePeers = Set<MCPeerID>()

    init(withUser user: User) {

        localPeerID = MCPeerID(displayName: user.id)
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: PeerToPeerNetworkClient.serviceType)
        browser  = MCNearbyServiceBrowser(peer: localPeerID, serviceType: PeerToPeerNetworkClient.serviceType)

        super.init()

        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

        browser.delegate = self
        browser.startBrowsingForPeers()
    }

    func sendMessage(message: String, to destinationID: String, completion: (error: NSError?) -> ()) {

        if let peer = availablePeers.filter({ peerID in
            return peerID.displayName == destinationID
        }).first {

            createSession()
            browser.invitePeer(peer, toSession: self.currentSession, withContext: nil, timeout: 10)
        } else {
            completion(error: NSError(domain: "Peer2Peer", code: 0, userInfo: ["reason": "No peer:\(destinationID) found nearby."]))
        }
    }

    private func createSession() {

        currentSession = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        currentSession.delegate = self
    }
}

extension PeerToPeerNetworkClient: MCNearbyServiceAdvertiserDelegate {

    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {

        createSession()

        print("Did receive invitation from: \(peerID.displayName)")
        invitationHandler(true, currentSession)
    }


    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {

        print("Failed to advertise with error: \(error)")
    }
}

extension PeerToPeerNetworkClient: MCNearbyServiceBrowserDelegate {

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

        print("Found peer: \(peerID.displayName) with discoveryInfo: \(info)")
        availablePeers.insert(peerID)
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {

        print("Lost peer: \(peerID.displayName)")
        availablePeers.remove(peerID)
    }

    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {

        print("Failed to browse with error: \(error)")
    }
}

extension PeerToPeerNetworkClient: MCSessionDelegate {

    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
    }

    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }

    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
}

extension MCSessionState {

    func stringValue() -> String {
        
        switch(self) {
        case .NotConnected: return "NotConnected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        default: return "Unknown"
        }
    }
}
