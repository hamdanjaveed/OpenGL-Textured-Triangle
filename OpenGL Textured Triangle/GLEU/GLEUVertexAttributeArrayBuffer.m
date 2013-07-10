//
//  GLEUVertexAttributeArrayBuffer.m
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

#import "GLEUVertexAttributeArrayBuffer.h"

@interface GLEUVertexAttributeArrayBuffer () {
    // The name or handle for this vertex buffer.
    GLuint name;
}

// The size of the buffer in bytes.
@property (nonatomic) GLsizeiptr size;
// The size of information to skip in order to get to the next data value.
@property (nonatomic) GLsizeiptr stride;
@end

@implementation GLEUVertexAttributeArrayBuffer

// Initialize the buffer.
- (id)initWithStride:(GLsizeiptr)stride
    numberOfVertices:(GLsizei)count
                data:(const GLvoid *)data
               usage:(GLenum)usage {
    
    // Check for bad parameters.
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(data != NULL);
    
    // Initialize.
    self = [super init];
    if (self) {
        // Assign parameters.
        self.stride = stride;
        // size = (how big one element is) * (how many elements)
        self.size = self.stride * count;
        
        // Create the buffer.
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        glBufferData(GL_ARRAY_BUFFER, self.size, data, usage);
        
        // Check to see if the buffer was created successfully.
        NSAssert(name != 0, @"Failed to generate name.");
    }
    return self;
}

// Re-initialize the buffer.
- (void)reInitWithStride:(GLsizeiptr)stride
        numberOfVertices:(GLsizei)count
                    data:(const GLvoid *)data {
    
    
    // Check for bad parameters.
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(data != NULL);
    NSAssert(name != 0, @"Name is 0.");
    
    // Update the parameters.
    self.stride = stride;
    self.size = self.stride * count;
    
    // Re-bind the buffer and send the updated data.
    glBindBuffer(GL_ARRAY_BUFFER, name);
    glBufferData(GL_ARRAY_BUFFER, self.size, data, GL_DYNAMIC_DRAW);
}

// Prepare the buffer for drawing.
- (void)prepareToDrawWithAttribute:(GLuint)attribute
                  numberOfVertices:(GLint)count
                            offset:(GLsizeiptr)offset
             shouldEnableAttribute:(BOOL)enable {
    
    // Check for bad parameters.
    // Count should be either 1, 2 or 3
    NSParameterAssert(count > 0 && count < 4);
    // TODO
    NSParameterAssert(self.stride > offset);
    // We only want to draw if the buffer exists.
    NSAssert(name != 0, @"Name for vertex buffer is 0.");
    
    // Bind ourselves to GL_ARRAY_BUFFER
    glBindBuffer(GL_ARRAY_BUFFER, name);
    
    // Enable an attribute if needed
    if (enable) {
        glEnableVertexAttribArray(attribute);
    }
    
    // Feed vertex position information, parameters are as follows:
    // 1 - what attribute the data refers to
    // 2 - the size/dimension of the data
    // 3 - the type of data (will always be GL_FLOAT)
    // 4 - if the data is normalized (will always be GL_FALSE)
    // 5 - the stride, how many bytes to skip till the next value
    // 6 - the position of the data relative to the first position (NULL means access the first value)
    glVertexAttribPointer(attribute, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
}

// Draw the vertex buffer.
- (void)drawVertexArrayWithMode:(GLenum)mode
               startVertexIndex:(GLint)first
               numberOfVertices:(GLsizei)count {
    
    // Check to see if there is enough information to draw compared to what's being requested.
    // size >= (number of indices) * (size of each index)
    NSAssert(self.size >= ((first + count) * self.stride), @"Attempted to draw more data than available.");
    
    // Draw the array.
    glDrawArrays(mode, first, count);
}

// Delete the buffer from the current context.
- (void)dealloc {
    // Delete the buffer.
    if (name != 0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}

@end
