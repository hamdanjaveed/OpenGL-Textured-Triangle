//
//  GLKEffectPropertyTexture+GLEUEffectPropertyTexture.m
//  OpenGL Textured Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "GLKEffectPropertyTexture+GLEUEffectPropertyTexture.h"

@implementation GLKEffectPropertyTexture (GLEUEffectPropertyTexture)

// Set the parameter with the value.
- (void)gleuSetParameter:(GLenum)parameter
                   value:(GLint)value {
    
    // Bind this texture to the current texture buffer.
    glBindTexture(self.target, self.name);
    
    // Change the parameter.
    glTexParameteri(self.target, parameter, value);
}

@end
