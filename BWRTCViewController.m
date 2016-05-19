//
// Created by Boomerweb iMac on 21/03/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "BWRTCViewController.h"
#import "BWRTCViewController+RTCObjects.h"
#import "BWRTCViewController+PeerConnectionDelegate.h"
#import "BWRTCViewController+SessionDescriptionDelegate.h"

#import "OGLViewController+LifeCycle.h"
#import "Macros.h"

#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>

@implementation BWRTCViewController

// define which variables should be instance variables
#define peerConnections     self.peerConnections
#define localVideoTrack     self.localVideoTrack
#define localAudioTrack     self.localAudioTrack
#define localMediaStream    self.localMediaStream
#define remoteVideoTrack    self.remoteVideoTrack
#define localVideoView      self.localVideoView
#define localVideoView2     self.localVideoView2
#define remoteVideoView     self.remoteVideoView

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // initialize webrtc
    [self initPeerConnectionFactory];
    NSLog(@"peerconnection factory: %@", peerConnectionFactory);
    
    // create a string for each camera to identify it
    [self initCameraIds];
    NSLog(@"camera ids: %@ | %@", backCameraId, frontCameraId);
    
    // set constraints for resolution/framerate/bandwidth
    [self initMediaConstraints];
    NSLog(@"media constraints: %@", mediaConstraints);
    
    // create a video capturer and video source
    [self initVideoSource];
    NSLog(@"localVideoSource: %@", localVideoSource);
    
    // create an iceservers array
    [self initIceServers];
    NSLog(@"ice servers: %@", iceServers);
    
    // create a constraints object to use for peerconnections
    [self initConnectionConstraints];
    NSLog(@"connection constraints: %@", connectionConstraints);
    
    // create a peerconnections array
    [self initPeerConnections];
    NSLog(@"peerconnections: %@", peerConnections);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [localMediaStream removeVideoTrack:localVideoTrack];
    [localMediaStream removeAudioTrack:localAudioTrack];
    
    for (RTCPeerConnection *peerConnection in peerConnections) {
        for (RTCMediaStream *localStream in peerConnection.localStreams) {
            [peerConnection removeStream:localStream];
        }
        [peerConnection close];
    }
    [peerConnections removeAllObjects];
    
    [localVideoTrack removeRenderer:localVideoView];
    [remoteVideoTrack removeRenderer:remoteVideoView];
}

- (void) initIceServers {
    if (!iceServers) {
        iceServers = @[
            [[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"turn:turn.boomerweb.nl:3478"] username:@"bart" password:@"1234"],
            [[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"turn:numb.viagenie.ca:3478"] username:@"c288652@trbvn.com " password:@"1234"],
            [[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"stun:stun.boomerweb.nl:3478"] username:@"" password:@""]
        ];
    }
}

- (void) initCameraIds {
    if (!frontCameraId || !backCameraId) {
        // loop through the available camera devices and pick the one labeled "front camera"
        for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (captureDevice.position == AVCaptureDevicePositionFront) {
                frontCameraId = [captureDevice localizedName];
                break;
            }
            if (captureDevice.position == AVCaptureDevicePositionBack) {
                backCameraId = [captureDevice localizedName];
            }
        }
        
        cameraId = frontCameraId;
    }
}

- (void) initConnectionConstraints {
    if (!connectionConstraints) {
        // init the constraints object
        connectionConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:@[
                [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
                [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]]
                                                                      optionalConstraints:@[
                                                                          [[RTCPair alloc] initWithKey:@"DtlsSrtpKeyAgreement" value:@"true"]]
        ];
    }
}

- (void) initMediaConstraints {
    if (!mediaConstraints) {
        // retrieve system information and set device name
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([deviceName isEqualToString:@"iPad1,1"] || [deviceName isEqualToString:@"iPad2,1"] || [deviceName isEqualToString:@"iPad2,2"] || [deviceName isEqualToString:@"iPad2,3"] || [deviceName isEqualToString:@"iPad2,4"]) {
            // use these constraints on crappy devices
            mediaConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:@[
                    [[RTCPair alloc] initWithKey:@"minWidth" value:@"192"],
                    [[RTCPair alloc] initWithKey:@"minHeight" value:@"144"],
                    [[RTCPair alloc] initWithKey:@"maxWidth" value:@"352"],
                    [[RTCPair alloc] initWithKey:@"maxHeight" value:@"288"]
            ]                                                        optionalConstraints:@[]];
        } else {
            mediaConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:@[/*
                [[RTCPair alloc] initWithKey:@"minWidth" value:@"640"],
                [[RTCPair alloc] initWithKey:@"minHeight" value:@"480"],
                [[RTCPair alloc] initWithKey:@"maxWidth" value:@"1280"],
                [[RTCPair alloc] initWithKey:@"maxHeight" value:@"760"]*/]
                                                                     optionalConstraints:@[]];
        }
    }
}

- (void) initPeerConnectionFactory {
    if (!peerConnectionFactory) {
        peerConnectionFactory = [[RTCPeerConnectionFactory alloc] init];
        [RTCPeerConnectionFactory initializeSSL];
    }
}

- (void) initPeerConnections {
    if (!peerConnections) {
        peerConnections = [[NSMutableArray<RTCPeerConnection *> alloc] init];
    }
}

- (void) initVideoSource {
    // create a capturer and video source
    if (!localVideoCapturer) {
        localVideoCapturer = [RTCVideoCapturer capturerWithDeviceName:cameraId];
    }
    if (!localVideoSource) {
        localVideoSource = [peerConnectionFactory videoSourceWithCapturer:localVideoCapturer constraints:mediaConstraints];
    }
}

// create a local media stream, an audio and a video track
// add tracks to the stream and add the stream to the peerconnection
- (void) createLocalMediaStream {
    // create the media stream to use in peerconnections
    if (!localMediaStream) {
        localMediaStream = [peerConnectionFactory mediaStreamWithLabel:@"ARDAMS"];
    }
    
    // create tracks to hook media up to the media stream
    if (!localVideoTrack || !localAudioTrack) {
        localVideoTrack = [peerConnectionFactory videoTrackWithID:@"ARDAMSv0" source:localVideoSource];
        localAudioTrack = [peerConnectionFactory audioTrackWithID:@"audio0"];
        NSLog(@"localVideoTrack: %@ localAudioTrack: %@", localVideoTrack, localAudioTrack);
    }
    
    // add the tracks to the media stream
    [localMediaStream addVideoTrack:localVideoTrack];
    [localMediaStream addAudioTrack:localAudioTrack];
    
    // add the media stream to the peerconnections
    for (RTCPeerConnection *peerConnection in peerConnections) {
        [peerConnection addStream:localMediaStream];
        NSLog(@"Added %@ to %@", localMediaStream, peerConnection);
    }
}

- (void) updateViews {
    dispatch_async(MAIN, ^(void) {
        CGRect localVideoFrame = self.view.frame;
        CGRect remoteVideoFrame = self.view.frame;
        
        if (localVideoFrame.size.width > localVideoFrame.size.height) {
            localVideoFrame.size.width = 320;
            localVideoFrame.size.height = 240;
        } else {
            localVideoFrame.size.width = 240;
            localVideoFrame.size.height = 320;
        }
        // create renderers
        if (!localVideoView) {
            localVideoView = [[OGLViewController alloc] initWithFrame:self.view.frame andTextureParameter:GL_LINEAR];
            [self.view addSubview:localVideoView.view];
            [self.view sendSubviewToBack:localVideoView.view];
        }
        [localVideoTrack addRenderer:localVideoView];
        
        if (!remoteVideoView) {
            remoteVideoView = [[OGLViewController alloc] initWithFrame:remoteVideoFrame andTextureParameter:GL_NEAREST];
            [self.view addSubview:remoteVideoView.view];
            [self.view sendSubviewToBack:remoteVideoView.view];
        }
        if (remoteVideoTrack) {
            [remoteVideoTrack addRenderer:remoteVideoView];
            [localVideoView setOrigin:CGPointMake(0, 0)];
            [localVideoView setSize:localVideoFrame.size];
        }
    });
}

- (void)setRemoteVideoTrackFromStream:(RTCMediaStream *)stream {
    remoteVideoTrack = stream.videoTracks[0];
    [self updateViews];
}

- (void) callerSequence {
    // create a peerconnection
    [peerConnections addObject:[peerConnectionFactory peerConnectionWithICEServers:iceServers constraints:connectionConstraints delegate:self]];
    
    // create local media stream, add to peerconnections
    [self createLocalMediaStream];
    [self updateViews];
}

- (void) startNegotiating {
    for (RTCPeerConnection *peerConnection in peerConnections) {
        [peerConnection createOfferWithDelegate:self constraints:mediaConstraints];
    }
}

- (void) receivedSessionDescription:(NSString *)sdp withType:(NSString *)type {
    RTCSessionDescription *sessionDescription = [[RTCSessionDescription alloc] initWithType:type sdp:sdp];
    
    if ([type isEqualToString:@"offer"]) {
        // create a peerconnection
        [peerConnections addObject:[peerConnectionFactory peerConnectionWithICEServers:iceServers constraints:connectionConstraints delegate:self]];
    }
    
    for (RTCPeerConnection *peerConnection in peerConnections) {
        [peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:sessionDescription];
    }
}

- (void) receivedIceCandidate:(NSString *)candidate sdpMid:(NSString *)sdpMid sdpMLineIndex:(NSInteger)sdpMLineIndex {
    RTCICECandidate *iceCandidate = [[RTCICECandidate alloc] initWithMid:sdpMid index:sdpMLineIndex sdp:candidate];
    
    for (RTCPeerConnection *peerConnection in peerConnections) {
        [peerConnection addICECandidate:iceCandidate];
    }
}

@end
