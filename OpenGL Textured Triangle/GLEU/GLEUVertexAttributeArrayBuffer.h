//
//  GLEUVertexAttributeArrayBuffer.h
//  OpenGL Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//
//  This class encapsulates an OpenGL vertex attribute array buffer, and provides
//  all the neccessary methods to create and use the vertex buffer. This class can
//  be used to hold information for any of the vertex attributes available in
//  OpenGL ES 2.0.
//
//  This class is part of the GLEU (OpenGL Extended Utility) package. The aim of GLEU
//  is to minimize the number of OpenGL calls made in the main classes of an app for
//  both reducing error prone code and to simplify code.
//

#import <GLKit/GLKit.h>

@interface GLEUVertexAttributeArrayBuffer : NSObject

// Initializes the vertex buffer with the passed in values.
- (id)initWithStride:(GLsizeiptr)stride
    numberOfVertices:(GLsizei)count
                data:(const GLvoid *)data
               usage:(GLenum)usage;

// Re-initialize the vertex buffer with updated coordinates.
- (void)reInitWithStride:(GLsizeiptr)stride
        numberOfVertices:(GLsizei)count
                    data:(const GLvoid *)data;

// Prepares the vertex buffer to draw itself.
- (void)prepareToDrawWithAttribute:(GLuint)attribute
                  numberOfVertices:(GLint)count
                            offset:(GLsizeiptr)offset
             shouldEnableAttribute:(BOOL)enable;

// Draws the vertex buffer.
- (void)drawVertexArrayWithMode:(GLenum)mode
               startVertexIndex:(GLint)first
               numberOfVertices:(GLsizei)count;

@end
