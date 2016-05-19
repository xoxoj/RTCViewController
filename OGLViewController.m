//
// Created by Boomerweb iMac on 21/03/16.
// Copyright (c) 2016 BOOMERWEB. All rights reserved.
//

#import "OGLViewController.h"

const GLubyte indices[] = { 0,1,2, 2,3,0 };

Vertex vertices[] = {
    {{-1.0f, -1.0f, 0.0f},{0.0f, 1.0f}},//bottom left
    {{ 1.0f, -1.0f, 0.0f},{1.0f, 1.0f}},//bottom right
    {{ 1.0f,  1.0f, 0.0f},{1.0f, 0.0f}},//top right
    {{-1.0f,  1.0f, 0.0f},{0.0f, 0.0f}},//top left
};

@implementation OGLViewController

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)renderFrame:(RTCI420Frame*)frame {
    if ([[NSDate date] timeIntervalSinceDate:self.timeOfLastFrame] > 1.0f/24.0f) {
        self.timeOfLastFrame = [NSDate date];
        
        self.videoWidth = (int)frame.width;
        self.videoHeight = (int)frame.height;
        
        [self prepareTextureSlot:textureYSlot forActiveTexture:1 withTexture:texY width:(GLint)frame.width height:(GLint)frame.height plane:frame.yPlane];
        [self prepareTextureSlot:textureUSlot forActiveTexture:2 withTexture:texU width:(GLint)frame.chromaWidth height:(GLint)frame.chromaHeight plane:frame.uPlane];
        [self prepareTextureSlot:textureVSlot forActiveTexture:3 withTexture:texV width:(GLint)frame.chromaWidth height:(GLint)frame.chromaHeight plane:frame.vPlane];
        [(GLKView*)self.view display];
    }
}

- (void) prepareTextureSlot:(GLint)textureSlot forActiveTexture:(GLenum)index withTexture:(GLuint)tex width:(GLint)w height:(GLint)h plane:(const uint8_t *)p {
    glActiveTexture(GL_TEXTURE0+index);
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, w, h, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, p);
    glUniform1i(textureSlot, index);
}

- (void)setSize:(CGSize)size {
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height);
    
    if (self.videoWidth != 0 && self.videoHeight != 0) {
        if (self.bounds.size.width - self.videoWidth < self.bounds.size.height - self.videoHeight) {
            self.view.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.videoHeight * (self.bounds.size.width / self.videoWidth));
        } else {
            self.view.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.videoWidth * (self.bounds.size.height / self.videoHeight), self.bounds.size.height);
        }
    }
}

- (void) setOrigin:(CGPoint)origin {
    _bounds = CGRectMake(origin.x, origin.y, _bounds.size.width, _bounds.size.height);
}

@end
