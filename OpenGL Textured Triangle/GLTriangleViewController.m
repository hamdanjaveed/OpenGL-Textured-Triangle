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
    GLKVector3 position;
    // The texture coordinates of the vertex.
    GLKVector2 texture;
} vertex;

// The current triangle vertex data.
static vertex triangleVBData[] = {
    // top middle
    {{ 0.0f,  0.5f, 0.0f}, {0.5f, 1.0f}},
    // bottom left
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    // bottom right
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}
};

// The default vertex data for the triangle, the triangle is an equilateral triangle centered at (0, 0, 0).
static const vertex defaultTriangleVBData[] = {
    // top middle
    {{ 0.0f,  0.5f, 0.0f}, {0.5f, 1.0f}},
    // bottom left
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    // bottom right
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}
};

// 3 vectors that control the direction and distance that each vertex moves every frame.
static GLKVector3 movementVectors[] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

@interface GLTriangleViewController () <GLKViewDelegate>
// A vertex buffer for the triangle.
@property (strong, nonatomic) GLEUVertexAttributeArrayBuffer *triangleVertexBuffer;

// A GLKBaseEffect object to use some basic lighting effects (we're just going to use a constant white color).
@property (strong, nonatomic) GLKBaseEffect *effect;

// The U.I controls.
@property (weak, nonatomic) IBOutlet UISwitch *useLinearInterpolationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *repeatTextureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shouldAnimateSwitch;
@property (weak, nonatomic) IBOutlet UISlider *sOffset;
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
                                                                                 usage:GL_DYNAMIC_DRAW];
    
    // Setup grid texture.
    CGImageRef gridImage = [[UIImage imageNamed:@"Grid.png"] CGImage];
    GLKTextureInfo *gridTextureInfo = [GLKTextureLoader textureWithCGImage:gridImage
                                                                     options:nil
                                                                       error:NULL];
    
    self.effect.texture2d0.name = gridTextureInfo.name;
    self.effect.texture2d0.target = gridTextureInfo.target;
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
    [self.triangleVertexBuffer prepareToDrawWithAttribute:GLKVertexAttribTexCoord0
                                         numberOfVertices:2
                                                   offset:offsetof(vertex, texture)
                                    shouldEnableAttribute:YES];
    
    // Draw the triangle.
    [self.triangleVertexBuffer drawVertexArrayWithMode:GL_TRIANGLES
                                      startVertexIndex:0
                                      numberOfVertices:sizeof(triangleVBData) / sizeof(vertex)];
}

# pragma mark - Update U.I

// Called every frame, updates the triangle's position, and the texture parameters.
// Then re-initializes the triangle vertex buffer.
- (void)update {
    [self updateTriangleVertices];
    [self updateTextureParameters];
    
    [self.triangleVertexBuffer reInitWithStride:sizeof(vertex)
                               numberOfVertices:sizeof(triangleVBData) / sizeof(vertex)
                                           data:triangleVBData];
}

#define LOWER_BOUND -0.5f

// Updates the triangle vertices and the texture coordinates.
- (void)updateTriangleVertices {
    // Only update the vertices if the animate switch is on.
    if(self.shouldAnimateSwitch.isOn) {
        // For each vertex.
        for(int i = 0; i < 3; i++) {
            // Each dimension (x, y and z) first gets movementVectors' corresponding dimension
            // added on to it. Then if the particular vertex is going to go out of bounds, negate
            // the corresponding movement vector.
            
            triangleVBData[i].position.x += movementVectors[i].x;
            if(triangleVBData[i].position.x >= 1.0f || triangleVBData[i].position.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            triangleVBData[i].position.y += movementVectors[i].y;
            if(triangleVBData[i].position.y >= 1.0f || triangleVBData[i].position.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            triangleVBData[i].position.z += movementVectors[i].z;
            if(triangleVBData[i].position.z >= 1.0f || triangleVBData[i].position.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {
        // The animate button is off, so set the position of the triangle back to the default state.
        for(int i = 0; i < 3; i++) {
            triangleVBData[i].position.x = defaultTriangleVBData[i].position.x;
            triangleVBData[i].position.y = defaultTriangleVBData[i].position.y;
            triangleVBData[i].position.z = defaultTriangleVBData[i].position.z;
        }
    }
    
    // Adjust the S texture coordinates to slide texture and
    for(int i = 0; i < 3; i++) {
        triangleVBData[i].texture.s = (defaultTriangleVBData[i].texture.s + self.sOffset.value);
    }
}

// Updates the texture's wrapping mode and extrapolation mode.
- (void)updateTextureParameters {
    // Set the wrapping mode to either repeat the texture or repeat the edges.
    [self.effect.texture2d0 gleuSetParameter:GL_TEXTURE_WRAP_S
                                       value:(self.repeatTextureSwitch.isOn) ? GL_REPEAT : GL_CLAMP_TO_EDGE];
    // Set the extrapolation mode to either use linear interpolation or use the nearest pixel.
    [self.effect.texture2d0 gleuSetParameter:GL_TEXTURE_MAG_FILTER
                                       value:(self.useLinearInterpolationSwitch.isOn) ? GL_LINEAR : GL_NEAREST];
}

@end
