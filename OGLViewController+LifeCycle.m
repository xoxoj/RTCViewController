//
//  OGLViewController+LifeCycle.m
//  BZA
//
//  Created by Leo Weijenberg on 12-11-14.
//  Copyright (c) 2014 boomerweb. All rights reserved.
//

#include "OGLViewController+LifeCycle.h"

@implementation OGLViewController (LifeCycle)

- (OGLViewController*)initWithFrame:(CGRect)frame andTextureParameter:(GLenum)texParameter {
    //initialize opengl stuff
    [self createGLContext:frame];
    [self setFlags];
    
    [self createBufferObjects];
    [self prepareShaders];
    
    self.bounds = frame;
    
    self.timeOfLastFrame = [[NSDate alloc] initWithTimeIntervalSince1970:0.0];
    
    glGenTextures(1, &texY);
    glBindTexture(GL_TEXTURE_2D, texY);
    [self setTextureParameter:texParameter];
    
    glGenTextures(1, &texU);
    glBindTexture(GL_TEXTURE_2D, texU);
    [self setTextureParameter:texParameter];
    
    glGenTextures(1, &texV);
    glBindTexture(GL_TEXTURE_2D, texV);
    [self setTextureParameter:texParameter];
    
    return self;
}

- (void)createGLContext:(CGRect)frame {
    //prepare an opengl view
    self.view = [[GLKView alloc] initWithFrame:frame];
    ((GLKView *)self.view).context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    ((GLKView *)self.view).delegate = self;
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    
    //force redrawing
    ((GLKView *)self.view).enableSetNeedsDisplay = NO;
}

- (void)setFlags {
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
}

- (void)createBufferObjects {
    GLuint vbo;
    GLuint ibo;
    
    //generate a vertex buffer object to put vertex data in for opengl to draw
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    //generate an index buffer object, to let opengl know which groups of vertices are a triangle
    glGenBuffers(1, &ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
}

- (void)prepareShaders {
    GLuint vertexShader = [self compileShader:[[NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"shader" ofType:@"vs"]
                                                                         encoding:NSUTF8StringEncoding
                                                                            error:NULL] UTF8String]
                                       ofType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:[[NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"shader" ofType:@"fs"]
                                                                           encoding:NSUTF8StringEncoding
                                                                              error:NULL] UTF8String]
                                         ofType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    glUseProgram(programHandle);
    
    [self initShaderVariables:programHandle];
}

- (GLuint)compileShader:(const GLchar*)source ofType:(GLenum)type {
    const GLint length = (const GLint)strlen(source);
    GLuint handle = glCreateShader(type);
    glShaderSource(handle, 1, &source, &length);
    glCompileShader(handle);
    
    return handle;
}

- (void)initShaderVariables:(GLuint)programHandle {
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(-1.0f, 1.0f, -1.0f, 1.0f, 0.01f, 1000.0f);
    glUniformMatrix4fv(glGetUniformLocation(programHandle, "projection"), 1, GL_FALSE, projectionMatrix.m);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.0f);
    glUniformMatrix4fv(glGetUniformLocation(programHandle, "modelView"), 1, GL_FALSE, modelViewMatrix.m);
    
    glVertexAttribPointer((GLuint)glGetAttribLocation(programHandle, "pos"), 3, GL_FLOAT, GL_TRUE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, pos));
    glEnableVertexAttribArray((GLuint)glGetAttribLocation(programHandle, "pos"));
    
    glVertexAttribPointer((GLuint)glGetAttribLocation(programHandle, "uv_coord"), 2, GL_FLOAT, GL_TRUE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, uv));
    glEnableVertexAttribArray((GLuint)glGetAttribLocation(programHandle, "uv_coord"));
    
    textureYSlot = glGetUniformLocation(programHandle, "texY");
    textureUSlot = glGetUniformLocation(programHandle, "texU");
    textureVSlot = glGetUniformLocation(programHandle, "texV");
}

- (void)setTextureParameter:(GLenum)texParameter {
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, texParameter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, texParameter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

@end
