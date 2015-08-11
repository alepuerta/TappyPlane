//
//  TPGetReadyMenu.h
//  Tappy Plane
//
//  Created by Alejandro on 11/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPGetReadyMenu : SKNode

@property (nonatomic) CGSize size;

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;

-(void)show;
-(void)hide;

@end
