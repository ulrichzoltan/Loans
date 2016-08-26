//
//  PeerToPeerNetworkClient.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerToPeerNetworkClient: NSObject, NetworkClient {

    private struct SendMessageRequest {
        let message: NSData
        var completion: ((error: NSError?) -> ())
    }

    private static let serviceType = "loans-service";

    private let localPeerID: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private var currentSession: MCSession? = nil
    private var availablePeers = Set<MCPeerID>()

    private var sendMessageRequest: SendMessageRequest? = nil
    private weak var delegate: NetworkClientDelegate? = nil

    private var connectCompletion: ((error: NSError?) -> ())?


    required init(withUser user: User) {

        localPeerID = MCPeerID(displayName: user.id)
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: PeerToPeerNetworkClient.serviceType)
        browser  = MCNearbyServiceBrowser(peer: localPeerID, serviceType: PeerToPeerNetworkClient.serviceType)

        super.init()

        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

        browser.delegate = self
        browser.startBrowsingForPeers()
    }

    func openConnection(to: String, completion: ((error: NSError?) -> ())?) {

        if let peer = availablePeers.filter({ peerID in
            return peerID.displayName == to
        }).first {
            self.currentSession = createSession()
            self.currentSession!.delegate = self
            self.connectCompletion = completion
            browser.invitePeer(peer, toSession: self.currentSession!, withContext: nil, timeout: 10)
        } else {
            completion?(error: NSError(domain: "Peer2Peer", code: 0, userInfo: ["reason": "No peer:\(to) found nearby."]))
        }
    }

    func closeConnection(to: String) {

        currentSession?.delegate = nil
        currentSession?.disconnect()
        currentSession = nil
        connectCompletion = nil
    }

    func sendMessage(message: NSData, to destinationID: String, completion: (error: NSError?) -> ()) {

        do {
            try currentSession?.sendData(message,
                                         toPeers: self.currentSession!.connectedPeers,
                                         withMode: .Reliable)
            completion(error: nil)
        } catch {
            completion(error: NSError(domain: "Peer2Peer", code: 1, userInfo: ["reason": "Could not send data"]))
        }
    }

    func setDelegate(delegate: NetworkClientDelegate) {

        self.delegate = delegate
    }

    private func createSession() -> MCSession {

        return MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
    }
}

extension PeerToPeerNetworkClient: MCNearbyServiceAdvertiserDelegate {

    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {

        self.currentSession = createSession()
        self.currentSession!.delegate = self

        print("Did receive invitation from: \(peerID.displayName)")
        invitationHandler(true, currentSession!)
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

        guard session == self.currentSession else {
            return
        }

        switch state {

        case .Connected:

            if let completion = connectCompletion {
                completion(error: nil)
                connectCompletion = nil
            }

        case .NotConnected:

            if let completion = connectCompletion {
                completion(error: NSError(domain: "Peer2Peer", code: 1, userInfo: ["reason": "Could not establish connection"]))
                connectCompletion = nil
            }

            self.currentSession?.delegate = nil
            self.currentSession = nil

        case .Connecting:
            break
        }
    }

    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {

        NSLog("%@", "didReceiveData: \(String(data: data, encoding: NSUTF8StringEncoding)!)")
        self.delegate?.didReceive(data, from: peerID.displayName)
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
        }
    }
}
