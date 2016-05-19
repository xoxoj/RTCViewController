//
// Created by Boomerweb iMac on 11/04/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "BWRTCViewController.h"

#import "OGLViewController.h"

// rtc imports
#import <RTCPeerConnectionFactory.h>
#import <RTCPeerConnection.h>
#import <RTCAudioTrack.h>
#import <RTCVideoTrack.h>
#import <RTCICEServer.h>
#import <RTCMediaStream.h>
#import <RTCVideoCapturer.h>
#import <RTCPair.h>
#import <RTCMediaConstraints.h>
#import <RTCSessionDescription.h>
#import <RTCICECandidate.h>

// some static crap that can initialized once and reused the rest of the time
static NSArray *iceServers;
static RTCPeerConnectionFactory *peerConnectionFactory;
static NSMutableArray<RTCPeerConnection *> *peerConnections;

static RTCVideoCapturer *localVideoCapturer;
static RTCVideoSource *localVideoSource;

static RTCMediaConstraints *connectionConstraints;
static RTCMediaConstraints *mediaConstraints;

static NSString *frontCameraId, *backCameraId;
static NSString *cameraId;

@interface BWRTCViewController ()

@property (strong, nonatomic) NSMutableArray<RTCPeerConnection *> *peerConnections;

@property (strong, nonatomic) RTCMediaStream *localMediaStream;
@property (strong, nonatomic) RTCAudioTrack *localAudioTrack;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;

@property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;

@property (strong, nonatomic) OGLViewController* localVideoView;
@property (strong, nonatomic) OGLViewController* localVideoView2;
@property (strong, nonatomic) OGLViewController* remoteVideoView;

@end
