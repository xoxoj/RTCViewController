//
// Created by Boomerweb iMac on 21/03/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "BWViewController.h"

@protocol BWRTCViewControllerDelegate
@required
// these are called on the delegate
- (void) sendSessionDescription:(NSString *)sessionDescription_ withType:(NSString *)type_;
- (void) sendICECandidate:(NSString *)candidate_ sdpMid:(NSString *)sdpMid_ sdpMLineIndex:(NSInteger)sdpMLineIndex_;
@end

@interface BWRTCViewController : UIViewController

// call at initialisation if caller
- (void) callerSequence;

// call when callee is ready to receive an offer
- (void) startNegotiating;

// call when appropriate, sets sdp/ice in the peerconnection
- (void) receivedSessionDescription:(NSString *)sdp withType:(NSString *)type;
- (void) receivedIceCandidate:(NSString *)candidate sdpMid:(NSString *)sdpMid sdpMLineIndex:(NSInteger)sdpMLineIndex;

@end
