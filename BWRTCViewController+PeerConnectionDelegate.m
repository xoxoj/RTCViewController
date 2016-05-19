//
// Created by Boomerweb iMac on 21/03/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "BWRTCViewController+RTCObjects.h"
#import "BWRTCViewController+PeerConnectionDelegate.h"
#import "BWRTCViewController+SessionDescriptionDelegate.h"
#import "Macros.h"

@interface BWRTCViewController ()
- (void)setRemoteVideoTrackFromStream:(RTCMediaStream *)stream;
- (void)createLocalMediaStream;
@end

@implementation BWRTCViewController (PeerConnectionDelegate)

#pragma mark streams

- (void) peerConnection:(RTCPeerConnection *)peerConnection addedStream:(RTCMediaStream *)stream {
    NSLog(@"addedStream: %@", stream);
    
    [self setRemoteVideoTrackFromStream:stream];
    
    if (!peerConnection.localDescription) {
        [self createLocalMediaStream];
        [peerConnection createAnswerWithDelegate:self constraints:mediaConstraints];
    }
}

- (void) peerConnection:(RTCPeerConnection *)peerConnection removedStream:(RTCMediaStream *)stream {
    NSLog(@"removedStream: %@", stream);
}

- (void) peerConnection:(RTCPeerConnection *)peerConnection didOpenDataChannel:(RTCDataChannel *)dataChannel {
    NSLog(@"didOpenDataChannel: %@", dataChannel);
}

#pragma mark sdp

- (void) peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection {
    NSLog(@"peerConnectionOnRenegotiationNeeded");
}

#pragma mark ice

- (void) peerConnection:(RTCPeerConnection *)peerConnection gotICECandidate:(RTCICECandidate *)candidate {
    [(id<BWRTCViewControllerDelegate>)self sendICECandidate:candidate.sdp sdpMid:candidate.sdpMid sdpMLineIndex:candidate.sdpMLineIndex];
}

- (void) peerConnection:(RTCPeerConnection *)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState {
    NSLog(@"iceConnectionChanged: %d", newState);
}

- (void) peerConnection:(RTCPeerConnection *)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState {
    NSLog(@"iceGatheringChanged: %d", newState);
}

#pragma mark signaling

- (void) peerConnection:(RTCPeerConnection *)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged {
    NSLog(@"signalingStateChanged: %d", stateChanged);
}

@end
