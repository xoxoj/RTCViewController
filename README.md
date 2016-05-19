# RTCViewController
A drag and drop example of native WebRTC on iOS

    // your call view controller .h
    #import <BWRTCViewController.h>

    @interface CallViewController : BWRTCViewController <BWRTCViewControllerDelegate>
    @end

    // your call view controller .m
    - (void)viewDidLoad {
    [super viewDidLoad];
        if ([BWStorage rt][@"call"][@"target"]) {
            [super callerSequence];
        }
    }

    // received a remote sdp
    - (void) receivedSdp:(NSNotification *) notification {
        [super receivedSessionDescription:notification.object[@"sdp"] withType:notification.object[@"type"]];
    }

    // received a remote ice candidate
    - (void) receivedIce:(NSNotification *) notification {
        [super receivedIceCandidate:notification.object[@"ice"] sdpMid:notification.object[@"id"] sdpMLineIndex:[notification.object[@"index"] intValue]];
    }

    // got a local sdp
    - (void) sendSessionDescription:(NSString *)sessionDescription_ withType:(NSString *)type_ {
        // send sdp to remote
    }

    // got a local ice candidate
    - (void) sendICECandidate:(NSString *)candidate_ sdpMid:(NSString *)sdpMid_ sdpMLineIndex:(NSInteger)sdpMLineIndex_ {
        // send ice to remote
    }
