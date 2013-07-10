//
//  GLEUContext.h
//  OpenGL Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//
//  This is an EAGLContext but adds a clearColor property along with a clear: method
//  to simplify the clearing process of the context's frame buffer.
//
//  This class is part of the GLEU (OpenGL Extended Utility) package. The aim of GLEU
//  is to minimize the number of OpenGL calls made in the main classes of an app for
//  both reducing error prone code and to simplify code.
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface GLEUContext : EAGLContext
// A property to hold the color needed to clear the context's frame buffer.
// This needs to be set to a GLKVector4 in order to be used.
@property (nonatomic) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
@end
