//
//  OGLViewController.h
//  OpenGL ES Tutorial
//
//  Created by Leo Weijenberg on 10-11-14.
//  Copyright (c) 2014 boomerweb. All rights reserved.
//

#import <GLKit/GLKit.h>

#include <RTCVideoRenderer.h>
#include <RTCStatsDelegate.h>
#include <RTCI420Frame.h>

typedef struct {
    GLfloat pos[3];
    GLfloat uv[2];
} Vertex;

extern Vertex vertices[4];
extern const GLubyte indices[6];

@interface OGLViewController : GLKViewController <GLKViewDelegate, RTCVideoRenderer> {
    GLint textureYSlot;
    GLint textureUSlot;
    GLint textureVSlot;
    
    GLuint texY;
    GLuint texU;
    GLuint texV;
}

@property (nonatomic) CGRect bounds;

@property (strong,nonatomic) NSDate* timeOfLastFrame;

@property GLfloat videoWidth;
@property GLfloat videoHeight;

- (void) setOrigin:(CGPoint)origin;

@end
