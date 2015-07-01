//
//  TPGameScene.m
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPGameScene.h"

@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])   {
        NSLog(@"Size: %f %f", size.width, size.height);
    }
    return self;
}

@end
