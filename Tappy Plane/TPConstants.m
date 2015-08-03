//
//  TPConstants.m
//  Tappy Plane
//
//  Created by Alejandro on 15/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPConstants.h"

@implementation TPConstants

const uint32_t kTPCategoryPlane       = 0x1 << 0;
const uint32_t kTPCategoryGround      = 0x1 << 1;
const uint32_t kTPCategoryCollectable = 0x1 << 2;

NSString *const kTPKeyMountainUp = @"mountainUp";
NSString *const kTPKeyMountainDown = @"mountainDown";
NSString *const kTPKeyMountainUpAlternate = @"mountainUpAlternate";
NSString *const kTPKeyMountainDownAlternate = @"mountainDownAlternate";
NSString *const kTPKeyCollectableStar = @"CollectableStar";

@end
