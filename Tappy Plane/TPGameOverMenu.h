//
//  TPGameOverMenu.h
//  Tappy Plane
//
//  Created by Alejandro on 4/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;

@interface TPGameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;

-(instancetype)initWithSize:(CGSize)size;
-(void)show;

@end
