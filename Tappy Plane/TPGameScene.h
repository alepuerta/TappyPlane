//
//  TPGameScene.h
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TPCollectable.h"
#import "TPGameOverMenu.h"

@interface TPGameScene : SKScene <SKPhysicsContactDelegate, TPCollectableDelegate, TPGameOverMenuDelegate>

@end
