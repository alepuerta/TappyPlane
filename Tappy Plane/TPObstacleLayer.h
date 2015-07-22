//
//  TPObstacleLayer.h
//  Tappy Plane
//
//  Created by Alejandro on 19/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPScrollingNode.h"
#import "TPCollectable.h"

@interface TPObstacleLayer : TPScrollingNode

@property (nonatomic, weak) id<TPCollectableDelegate> collectableDelegate;

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
