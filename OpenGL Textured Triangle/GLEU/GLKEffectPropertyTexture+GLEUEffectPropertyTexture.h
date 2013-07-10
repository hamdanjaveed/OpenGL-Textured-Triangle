//
//  GLKEffectPropertyTexture+GLEUEffectPropertyTexture.h
//  OpenGL Textured Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLKEffectPropertyTexture (GLEUEffectPropertyTexture)

// Set the passed in parameter with the passed in value for a texture.
- (void)gleuSetParameter:(GLenum)parameter
                   value:(GLint)value;

@end
