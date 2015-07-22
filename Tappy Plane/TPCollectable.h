//
//  TPCollectable.h
//  Tappy Plane
//
//  Created by Alejandro on 22/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TPCollectable;

@protocol TPCollectableDelegate <NSObject>

-(void)wasCollected:(TPCollectable*)collectable;

@end

@interface TPCollectable : SKSpriteNode

@property (nonatomic, weak) id<TPCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

-(void)collect;

@end
