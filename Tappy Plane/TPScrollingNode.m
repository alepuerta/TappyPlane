//
//  TPScrollingNode.m
//  Tappy Plane
//
//  Created by Alejandro on 8/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPScrollingNode.h"

@implementation TPScrollingNode

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}


@end
