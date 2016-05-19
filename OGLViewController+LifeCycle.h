//
//  OGLViewController+LifeCycle.h
//  BZA
//
//  Created by Leo Weijenberg on 12-11-14.
//  Copyright (c) 2014 boomerweb. All rights reserved.
//

#include "OGLViewController.h"

@interface OGLViewController (LifeCycle)

- (OGLViewController*)initWithFrame:(CGRect)frame andTextureParameter:(GLenum)texParameter;
- (void)createGLContext:(CGRect)frame;
- (void)createBufferObjects;
- (void)prepareShaders;
- (GLuint)compileShader:(const GLchar*)source ofType:(GLenum)type;
- (void)initShaderVariables:(GLuint)programHandle;

@end
