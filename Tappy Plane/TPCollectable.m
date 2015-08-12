//
//  TPCollectable.m
//  Tappy Plane
//
//  Created by Alejandro on 22/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPCollectable.h"

@implementation TPCollectable

-(void)collect
{
    [self.collectionSound play];
    [self runAction:[SKAction removeFromParent]];
    if (self.delegate) {
        [self.delegate wasCollected:self];
    }
}

@end