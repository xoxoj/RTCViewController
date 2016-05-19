//
// Created by Boomerweb iMac on 21/03/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "BWRTCViewController.h"
#import "BWRTCViewController+RTCObjects.h"
#import "BWRTCViewController+PeerConnectionDelegate.h"
#import "BWRTCViewController+SessionDescriptionDelegate.h"
#import "Macros.h"

@implementation BWRTCViewController (SessionDescriptionDelegate)

- (void)peerConnection:(RTCPeerConnection *)peerConnection didCreateSessionDescription:(RTCSessionDescription *)sdp error:(NSError *)error {
    NSLog(@"didCreateSessionDescription: %@ error: %@", sdp.type, error);
    
    if (!error) {
        [peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
        [(id<BWRTCViewControllerDelegate>)self sendSessionDescription:sdp.description withType:sdp.type];
    }
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection didSetSessionDescriptionWithError:(NSError *)error {
    NSLog(@"peerConnection: %@ didSetSessionDescriptionWithError: %@", peerConnection, error);
}

@end
