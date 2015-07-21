//
//  TPPlane.h
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPPlane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
// Commented for the challenge
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;


-(void)flap;
-(void)setRandomColour;
-(void)update;
-(void)collide:(SKPhysicsBody*)body;
-(void)reset;


@end
