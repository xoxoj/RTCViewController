# RTCViewController
A drag and drop example of native WebRTC on iOS

These classes are meant as a starting point for native WebRTC on iOS. Simply extend a view controller on BWRTCViewController and set a delegate. Now you can start testing right away, without having to worry about implementing the entire call sequence yourself. You only have to worry about signaling.





    // your call view controller .h
    #import <BWRTCViewController.h>

    @interface CallViewController : BWRTCViewController <BWRTCViewControllerDelegate>
    @end


    // your call view controller .m
    - (void)viewDidLoad {
        [super viewDidLoad];
        if ([BWStorage rt][@"call"][@"target"]) {
            [super callerSequence];
            
            // wait until callee is ready to receive your offer, then call:
            [super startNegotiating];
        }
    }
    
    // received a remote sdp
    - (void)receivedSdp {
        [super receivedSessionDescription:/*your sdp description*/
                                 withType:/*your sdp type*/];
    }
    
    // received a remote ice candidate
    - (void)receivedIce {
        [super receivedIceCandidate:/*your ice candidate*/
                             sdpMid:/*your ice sdpMid*/
                      sdpMLineIndex:/*your ice sdpMLineIndex*/];
    }
    
    // got a local sdp
    - (void) sendSessionDescription:(NSString *)sessionDescription_
                           withType:(NSString *)type_ {
        // use your signaling interface to send the sdp to the remote peer
    }
    
    // got a local ice candidate
    - (void) sendICECandidate:(NSString *)candidate_
                       sdpMid:(NSString *)sdpMid_
                sdpMLineIndex:(NSInteger)sdpMLineIndex_ {
        // use your signaling interface to send the ice to the remote peer
    }
