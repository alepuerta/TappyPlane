//
//  TPScrollingNode.h
//  Tappy Plane
//
//  Created by Alejandro on 8/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPScrollingNode : SKNode

@property (nonatomic) CGFloat horizontalScrollSpeed;    // Distance to scroll per second.
@property (nonatomic) BOOL scrolling;

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed;

@end
