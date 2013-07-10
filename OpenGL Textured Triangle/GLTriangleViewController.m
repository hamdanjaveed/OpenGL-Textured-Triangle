//
//  GLTriangleViewController.m
//  OpenGL Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//
//  This class is responsible for drawing a triangle to the screen. The triangle will
//  be an equilateral triangle that is centered at the origin. The triangle will be
//  drawn with a texture, there will also be controls on the screen to control some
//  aspects of the texture.
//

#import "GLTriangleViewController.h"
#import "GLEU.h"

// A struct that contains information for one vertex.
typedef struct {
    // The position of the vertex in 3D-space.
    float position[3];
} vertex;

// The vertex data for the triangle, the triangle is an equilateral triangle centered at (0, 0, 0).
const vertex triangleVBData[] = {
    { 0.0f,  0.5f, 0.0f},
    {-0.5f, -0.5f, 0.0f},
    { 0.5f, -0.5f, 0.0f}
};

@interface GLTriangleViewController () <GLKViewDelegate>
// A vertex buffer for the triangle.
@property (strong, nonatomic) GLEUVertexAttributeArrayBuffer *triangleVertexBuffer;

// A GLKBaseEffect object to use some basic lighting effects (we're just going to use a constant white color).
@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation GLTriangleViewController

#pragma mark - ViewController lifecycle

// Called at launch, sets up opengl to draw the triangle.
// Needs to setup a context, an effect and the triangle vb.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get our GLKView and ensure that it is indeed a GLKView.
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLTriangleViewController's view is not a GLKView");
    
    // Create and set the view's context, and make it the current context.
    view.context = [[GLEUContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [GLEUContext setCurrentContext:view.context];
    
    // Initialize the effect and set it to use a constant white color.
    self.effect = [[GLKBaseEffect alloc] init];
    [self.effect setUseConstantColor:GL_TRUE];
    [self.effect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    // Set the clearColor for the view's context.
    [((GLEUContext *)view.context) setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];
    
    // Create the triangle vertex buffer.
    self.triangleVertexBuffer = [[GLEUVertexAttributeArrayBuffer alloc] initWithStride:sizeof(vertex)
                                                                      numberOfVertices:sizeof(triangleVBData) / sizeof(vertex)
                                                                                  data:triangleVBData
                                                                                 usage:GL_STATIC_DRAW];
}

// Called when going out of memory, should delete all contexts and buffers.
// Needs to set view's context to nil and delete the triangle buffer.
- (void)dealloc {
    // Get our view and set it's context to the current context.
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // Delete the triangle buffer.
    self.triangleVertexBuffer = nil;
    
    // Release the view's context out of memory.
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

# pragma mark - GLKViewDelegate

// Part of the GLKViewDelegate, draws the triangle.
// Needs to tell the effect to get ready for drawing, and then draw the triangle.
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // Tell the GLKBaseEffect to prepare itself to draw.
    [self.effect prepareToDraw];
    
    // Clear the context's back frame buffer
    [(GLEUContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    // Prepare the triangle vertex buffer for drawing.
    [self.triangleVertexBuffer prepareToDrawWithAttribute:GLKVertexAttribPosition
                                         numberOfVertices:sizeof(triangleVBData) / sizeof(vertex)
                                                   offset:offsetof(vertex, position)
                                    shouldEnableAttribute:YES];
    
    // Draw the triangle.
    [self.triangleVertexBuffer drawVertexArrayWithMode:GL_TRIANGLES
                                      startVertexIndex:0
                                      numberOfVertices:sizeof(triangleVBData) / sizeof(vertex)];
}

@end
