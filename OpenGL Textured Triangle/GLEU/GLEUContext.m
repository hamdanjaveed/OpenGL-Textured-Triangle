//
//  GLEUContext.m
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

#import "GLEUContext.h"

@implementation GLEUContext

// Sets the clearColor property that is used to clear the context's frame buffer.
- (void)setClearColor:(GLKVector4)clearColor {
    // Set the clearColor property.
    _clearColor = clearColor;
    // Make sure that we are the current context because the gl calls following this
    // need to be applied to this context.
    NSAssert(self == [[self class] currentContext], @"GLEUContext sent selector: %@, when it's not current context.", NSStringFromSelector(_cmd));
    
    // set the clear color for this context
    glClearColor(self.clearColor.r, self.clearColor.g, self.clearColor.b, self.clearColor.a);
}

// Clears the opengl render buffers.
- (void)clear:(GLbitfield)mask {
    glClear(mask);
}

@end
